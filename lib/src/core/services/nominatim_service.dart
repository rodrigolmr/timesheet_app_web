import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NominatimService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  
  Future<List<String>> getAddressSuggestions(String query) async {
    if (query.length < 3) {
      return [];
    }

    try {
      // Add ", Long Island" or ", NY" to help focus the search if not already present
      String searchQuery = query;
      if (!query.toLowerCase().contains('ny') && 
          !query.toLowerCase().contains('new york') &&
          !query.toLowerCase().contains('long island')) {
        searchQuery = '$query, Long Island, NY';
      }
      
      // Focus search on Long Island and surrounding areas
      final boundingBox = '${-74.5},${40.0},${-71.5},${42.0}'; // Long Island region
      
      final url = Uri.parse(
        '$_baseUrl/search'
        '?q=${Uri.encodeComponent(searchQuery)}'
        '&format=json'
        '&countrycodes=us'
        '&addressdetails=1'
        '&limit=20'
        '&viewbox=$boundingBox'
        '&bounded=0'
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'TimeSheetApp/1.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return data
            .where((place) {
              final displayName = place['display_name'] ?? '';
              final state = place['address']?['state'] ?? '';
              
              // Filter for NY, CT, NJ, MA addresses
              return state == 'New York' || 
                     state == 'Connecticut' || 
                     state == 'New Jersey' || 
                     state == 'Massachusetts' ||
                     displayName.contains('Long Island') ||
                     displayName.contains(', NY') ||
                     displayName.contains(', New York');
            })
            .map((place) {
              // Try to build address from components
              final address = place['address'] as Map<String, dynamic>?;
              if (address != null) {
                final houseNumber = address['house_number'] ?? '';
                final road = address['road'] ?? '';
                final city = address['city'] ?? 
                           address['town'] ?? 
                           address['village'] ?? 
                           address['hamlet'] ?? 
                           address['suburb'] ?? '';
                final state = address['state'] ?? '';
                final postcode = address['postcode'] ?? '';
                
                // Build the address string
                String formattedAddress = '';
                
                if (houseNumber.isNotEmpty && road.isNotEmpty) {
                  formattedAddress = '$houseNumber $road';
                } else if (road.isNotEmpty) {
                  formattedAddress = road;
                }
                
                if (city.isNotEmpty) {
                  if (formattedAddress.isNotEmpty) {
                    formattedAddress += ', $city';
                  } else {
                    formattedAddress = city;
                  }
                }
                
                if (state.isNotEmpty) {
                  formattedAddress += ', $state';
                  if (postcode.isNotEmpty) {
                    formattedAddress += ' $postcode';
                  }
                }
                
                if (formattedAddress.isNotEmpty) {
                  return _abbreviateAddress(formattedAddress);
                }
              }
              
              // Fallback to display name parsing
              final displayName = place['display_name'] ?? '';
              final parts = displayName.split(',');
              if (parts.length >= 3) {
                // Typically: house_number street, city, state ZIP, country
                final streetAndNumber = parts[0].trim();
                final city = parts[1].trim();
                final stateAndZip = parts[2].trim();
                
                // Clean up the format
                String formattedAddress = '$streetAndNumber, $city, $stateAndZip';
                
                // Remove 'United States' if it's at the end
                formattedAddress = formattedAddress
                    .replaceAll(', United States', '')
                    .replaceAll(', USA', '');
                
                return _abbreviateAddress(formattedAddress);
              }
              return _abbreviateAddress(displayName);
            })
            .toSet() // Remove duplicates
            .take(15)
            .toList();
      }
    } catch (e) {
      print('Error fetching address suggestions from Nominatim: $e');
    }

    return [];
  }

  String _abbreviateAddress(String address) {
    return address
        .replaceAll('Street', 'St')
        .replaceAll('Avenue', 'Ave')
        .replaceAll('Road', 'Rd')
        .replaceAll('Drive', 'Dr')
        .replaceAll('Lane', 'Ln')
        .replaceAll('Place', 'Pl')
        .replaceAll('Court', 'Ct')
        .replaceAll('Circle', 'Cir')
        .replaceAll('Boulevard', 'Blvd')
        .replaceAll('Highway', 'Hwy')
        .replaceAll('Turnpike', 'Tpke')
        .replaceAll('Parkway', 'Pkwy')
        .replaceAll('United States', 'USA')
        .replaceAll('New York', 'NY')
        .replaceAll('Connecticut', 'CT')
        .replaceAll('New Jersey', 'NJ')
        .replaceAll('Massachusetts', 'MA');
  }
}

// Provider for the Nominatim service
final nominatimServiceProvider = Provider<NominatimService>((ref) {
  return NominatimService();
});
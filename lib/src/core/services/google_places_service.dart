import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:timesheet_app_web/src/features/pigtail/presentation/providers/pigtail_providers.dart';

class GooglePlacesService {
  // Google Places API key
  static const String _apiKey = 'AIzaSyBWKxGeS-UH-zx1381QJoREiSQflgi9Vvg';
  static const String _baseUrl = 'https://places.googleapis.com/v1/places:autocomplete';
  
  final _uuid = const Uuid();
  String? _sessionToken;
  DateTime? _sessionStartTime;
  
  // Session tokens should be regenerated after 3 minutes or when a place is selected
  void _checkSessionToken() {
    if (_sessionToken == null || 
        _sessionStartTime == null ||
        DateTime.now().difference(_sessionStartTime!).inMinutes > 3) {
      _sessionToken = _uuid.v4();
      _sessionStartTime = DateTime.now();
    }
  }
  
  void resetSessionToken() {
    _sessionToken = null;
    _sessionStartTime = null;
  }

  Future<List<String>> getAddressSuggestions(String query) async {
    if (query.isEmpty || query.length < 3) {
      return [];
    }

    _checkSessionToken();

    try {
      // Rectangle covering all of Long Island and NYC area
      // Southwest corner: South of Staten Island and west of Manhattan
      const double swLat = 40.4774;  // South of Staten Island
      const double swLng = -74.2591; // West of Newark/Manhattan
      // Northeast corner: North of Bronx and east end of Long Island
      const double neLat = 41.1854;  // North of Long Island Sound
      const double neLng = -71.8562; // Montauk Point (east end of Long Island)

      // Amityville coordinates for distance calculation
      const double amityvilleLat = 40.6784;
      const double amityvilleLng = -73.4171;

      final body = {
        'input': query,
        'includedPrimaryTypes': ['street_address', 'route', 'geocode'],
        'locationBias': {
          'rectangle': {
            'low': {
              'latitude': swLat,
              'longitude': swLng,
            },
            'high': {
              'latitude': neLat,
              'longitude': neLng,
            },
          },
        },
        'origin': {
          'latitude': amityvilleLat,
          'longitude': amityvilleLng,
        },
        'sessionToken': _sessionToken,
        'languageCode': 'en-US',
        'regionCode': 'US',
      };

      print('Request URL: $_baseUrl');
      print('Request body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'suggestions.placePrediction.text,suggestions.placePrediction.placeId,suggestions.placePrediction.structuredFormat,suggestions.placePrediction.distanceMeters',
        },
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final suggestions = data['suggestions'] as List?;
        
        if (suggestions == null) return [];

        // Extract and sort suggestions
        final List<Map<String, dynamic>> suggestionsWithDistance = suggestions
            .where((s) => s['placePrediction'] != null)
            .map((s) {
              final prediction = s['placePrediction'];
              // Try different text fields based on what's available
              final text = prediction['text']?['text'] ?? 
                          prediction['structuredFormat']?['mainText']?['text'] ?? 
                          prediction['description'] ?? 
                          '';
              final distance = prediction['distanceMeters'] as int?;
              
              return {
                'text': text as String,
                'distance': distance ?? 999999, // Default to large distance if not provided
              };
            })
            .where((item) => (item['text'] as String).isNotEmpty)
            .where((item) {
              final text = item['text'] as String;
              return text.contains('NY') || 
                     text.contains('New York') ||
                     text.contains('CT') ||
                     text.contains('Connecticut') ||
                     text.contains('NJ') ||
                     text.contains('New Jersey') ||
                     text.contains('MA') ||
                     text.contains('Massachusetts');
            })
            .toList();
        
        // Sort by distance from Amityville
        suggestionsWithDistance.sort((a, b) => a['distance'].compareTo(b['distance']));
        
        // Return sorted addresses
        return suggestionsWithDistance
            .map((item) => _abbreviateAddress(item['text'] as String))
            .toList();
      } else {
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching address suggestions: $e');
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

// Provider for the Google Places service
final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref) {
  return GooglePlacesService();
});

// Provider for address suggestions with caching
final addressSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, query) async {
  if (query.isEmpty || query.length < 3) return [];
  
  final googlePlacesService = ref.read(googlePlacesServiceProvider);
  return googlePlacesService.getAddressSuggestions(query);
});

// Provider for all unique addresses from the database
final allUniqueAddressesProvider = FutureProvider<List<String>>((ref) async {
  try {
    // Get all pigtails from the database
    final pigtails = await ref.watch(pigtailsProvider.future);
    
    // Extract unique addresses
    final addresses = pigtails
        .map((pigtail) => pigtail.address)
        .where((address) => address.isNotEmpty)
        .toSet()
        .toList();
    
    // Sort alphabetically
    addresses.sort();
    
    return addresses;
  } catch (e) {
    return [];
  }
});

// Global provider for address suggestions including existing addresses
final globalAddressSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, query) async {
  if (query.isEmpty || query.length < 3) return [];
  
  // Get existing addresses
  final existingAddresses = await ref.read(allUniqueAddressesProvider.future);
  
  // Filter existing addresses by query
  final filteredExisting = existingAddresses
      .where((address) => address.toLowerCase().contains(query.toLowerCase()))
      .toList();
  
  // Get new suggestions from Google Places
  final googleSuggestions = await ref.read(addressSuggestionsProvider(query).future);
  
  // Combine and remove duplicates
  final allSuggestions = [...filteredExisting, ...googleSuggestions];
  return allSuggestions.toSet().toList();
});
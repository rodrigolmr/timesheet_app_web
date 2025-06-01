import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GooglePlacesService {
  // You'll need to add your Google Places API key here
  // Get it from: https://console.cloud.google.com/
  static const String _apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<String>> getAddressSuggestions(String query) async {
    if (query.isEmpty || _apiKey == 'YOUR_GOOGLE_PLACES_API_KEY') {
      return [];
    }

    try {
      // Focus search on Long Island area (centered around Amityville)
      const double lat = 40.6784;
      const double lng = -73.4171;
      const int radius = 50000; // 50km radius

      final url = Uri.parse(
        '$_baseUrl/autocomplete/json'
        '?input=${Uri.encodeComponent(query)}'
        '&types=address'
        '&location=$lat,$lng'
        '&radius=$radius'
        '&components=country:us'
        '&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;

        return predictions
            .map((prediction) => prediction['description'] as String)
            .where((address) => 
              address.contains('NY') || 
              address.contains('New York') ||
              address.contains('CT') ||
              address.contains('Connecticut') ||
              address.contains('NJ') ||
              address.contains('New Jersey') ||
              address.contains('MA') ||
              address.contains('Massachusetts')
            )
            .map((address) => _abbreviateAddress(address))
            .toList();
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
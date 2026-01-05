import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class AddressSuggestion {
  final String displayName;
  final LatLng location;

  AddressSuggestion({required this.displayName, required this.location});
}

class AddressSearchService {
  static Future<List<AddressSuggestion>> search(String query) async {
    if (query.length < 3) return [];

    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=$query'
      '&format=json'
      '&addressdetails=1'
      '&limit=5'
      '&countrycodes=fi',
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'flutter_flower_shop',
      },
    );

    if (response.statusCode != 200) {
      return [];
    }

    final List data = jsonDecode(response.body);

    return data.map((item) {
      return AddressSuggestion(
        displayName: item['display_name'],
        location: LatLng(double.parse(item['lat']), double.parse(item['lon'])),
      );
    }).toList();
  }
}

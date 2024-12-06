import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_url.dart';

/// Network classes to call the api
class WeatherService {

  Future<Map<String, dynamic>> fetchWeatherByCoords(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('${AppUrl.Baseurl}?lat=$lat&lon=$lon'),
      headers: {'X-Api-Key': AppUrl.apiKey},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

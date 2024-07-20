import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static const String apiKey = '1f1c64eb11a3436180c185318242007';

  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

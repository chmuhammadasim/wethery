import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = '1f1c64eb11a3436180c185318242007';
  String city = 'Paris';
  late Map<String, dynamic> weatherData;
  TextEditingController cityController = TextEditingController();

  Future<void> fetchWeather(String city) async {
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in $city'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Enter city name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      city = cityController.text;
                    });
                    fetchWeather(city);
                  },
                  child: const Text('Get Weather'),
                ),
              ],
            ),
          ),
          weatherData == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: ${weatherData['location']['name']}, ${weatherData['location']['region']}, ${weatherData['location']['country']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Latitude: ${weatherData['location']['lat']}, Longitude: ${weatherData['location']['lon']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Local Time: ${weatherData['location']['localtime']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Temperature: ${weatherData['current']['temp_c']} °C / ${weatherData['current']['temp_f']} °F',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Condition: ${weatherData['current']['condition']['text']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Image.network(
                            'https:${weatherData['current']['condition']['icon']}'),
                        Text(
                          'Wind: ${weatherData['current']['wind_mph']} mph / ${weatherData['current']['wind_kph']} kph, Direction: ${weatherData['current']['wind_dir']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Pressure: ${weatherData['current']['pressure_mb']} mb / ${weatherData['current']['pressure_in']} in',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Precipitation: ${weatherData['current']['precip_mm']} mm / ${weatherData['current']['precip_in']} in',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Humidity: ${weatherData['current']['humidity']}%',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Cloud: ${weatherData['current']['cloud']}%',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Feels Like: ${weatherData['current']['feelslike_c']} °C / ${weatherData['current']['feelslike_f']} °F',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Wind Chill: ${weatherData['current']['windchill_c']} °C / ${weatherData['current']['windchill_f']} °F',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Heat Index: ${weatherData['current']['heatindex_c']} °C / ${weatherData['current']['heatindex_f']} °F',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Dew Point: ${weatherData['current']['dewpoint_c']} °C / ${weatherData['current']['dewpoint_f']} °F',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Visibility: ${weatherData['current']['vis_km']} km / ${weatherData['current']['vis_miles']} miles',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'UV Index: ${weatherData['current']['uv']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Gust: ${weatherData['current']['gust_mph']} mph / ${weatherData['current']['gust_kph']} kph',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

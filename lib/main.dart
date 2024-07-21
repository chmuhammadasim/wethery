import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

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
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen>
    with SingleTickerProviderStateMixin {
  final String apiKey = '1f1c64eb11a3436180c185318242007';
  String city = 'Paris';
  Map<String, dynamic>? weatherData;
  final TextEditingController cityController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
        isLoading = false;
        _animationController.forward(from: 0.0);
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load weather data';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherByLocation(Position position) async {
    final String location = '${position.latitude},${position.longitude}';
    await fetchWeather(location);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await fetchWeatherByLocation(position);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    fetchWeather(city);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in $city'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _getCurrentLocation,
          ),
        ],
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
                    if (cityController.text.isNotEmpty) {
                      setState(() {
                        city = cityController.text;
                      });
                      fetchWeather(city);
                    }
                  },
                  child: const Text('Get Weather'),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty)
            Center(child: Text(errorMessage))
          else if (weatherData != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: FadeTransition(
                  opacity: _animation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeatherInfoRow(
                        'Location:',
                        '${weatherData!['location']['name']}, ${weatherData!['location']['region']}, ${weatherData!['location']['country']}',
                      ),
                      _buildWeatherInfoRow(
                        'Latitude:',
                        '${weatherData!['location']['lat']}',
                      ),
                      _buildWeatherInfoRow(
                        'Longitude:',
                        '${weatherData!['location']['lon']}',
                      ),
                      _buildWeatherInfoRow(
                        'Local Time:',
                        '${weatherData!['location']['localtime']}',
                      ),
                      const SizedBox(height: 20),
                      _buildWeatherInfoRow(
                        'Temperature:',
                        '${weatherData!['current']['temp_c']} °C / ${weatherData!['current']['temp_f']} °F',
                      ),
                      _buildWeatherInfoRow(
                        'Condition:',
                        '${weatherData!['current']['condition']['text']}',
                      ),
                      Image.network(
                        'https:${weatherData!['current']['condition']['icon']}',
                      ),
                      _buildWeatherInfoRow(
                        'Wind:',
                        '${weatherData!['current']['wind_mph']} mph / ${weatherData!['current']['wind_kph']} kph, Direction: ${weatherData!['current']['wind_dir']}',
                      ),
                      _buildWeatherInfoRow(
                        'Pressure:',
                        '${weatherData!['current']['pressure_mb']} mb / ${weatherData!['current']['pressure_in']} in',
                      ),
                      _buildWeatherInfoRow(
                        'Precipitation:',
                        '${weatherData!['current']['precip_mm']} mm / ${weatherData!['current']['precip_in']} in',
                      ),
                      _buildWeatherInfoRow(
                        'Humidity:',
                        '${weatherData!['current']['humidity']}%',
                      ),
                      _buildWeatherInfoRow(
                        'Cloud:',
                        '${weatherData!['current']['cloud']}%',
                      ),
                      _buildWeatherInfoRow(
                        'Feels Like:',
                        '${weatherData!['current']['feelslike_c']} °C / ${weatherData!['current']['feelslike_f']} °F',
                      ),
                      _buildWeatherInfoRow(
                        'Wind Chill:',
                        '${weatherData!['current']['windchill_c']} °C / ${weatherData!['current']['windchill_f']} °F',
                      ),
                      _buildWeatherInfoRow(
                        'Heat Index:',
                        '${weatherData!['current']['heatindex_c']} °C / ${weatherData!['current']['heatindex_f']} °F',
                      ),
                      _buildWeatherInfoRow(
                        'Dew Point:',
                        '${weatherData!['current']['dewpoint_c']} °C / ${weatherData!['current']['dewpoint_f']} °F',
                      ),
                      _buildWeatherInfoRow(
                        'Visibility:',
                        '${weatherData!['current']['vis_km']} km / ${weatherData!['current']['vis_miles']} miles',
                      ),
                      _buildWeatherInfoRow(
                        'UV Index:',
                        '${weatherData!['current']['uv']}',
                      ),
                      _buildWeatherInfoRow(
                        'Gust:',
                        '${weatherData!['current']['gust_mph']} mph / ${weatherData!['current']['gust_kph']} kph',
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

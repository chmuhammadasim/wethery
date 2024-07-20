import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: weatherProvider.fetchWeatherForSavedCities,
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
                      weatherProvider.addCity(cityController.text);
                      cityController.clear();
                    }
                  },
                  child: const Text('Add City'),
                ),
              ],
            ),
          ),
          weatherProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : weatherProvider.errorMessage != null
                  ? Center(child: Text(weatherProvider.errorMessage!))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: weatherProvider.savedCities.length,
                        itemBuilder: (context, index) {
                          String city = weatherProvider.savedCities[index];
                          var weather = weatherProvider.weatherData[city];
                          return Dismissible(
                            key: Key(city),
                            onDismissed: (direction) {
                              weatherProvider.removeCity(city);
                            },
                            background: Container(color: Colors.red),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  '${weather['location']['name']}, ${weather['location']['region']}, ${weather['location']['country']}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Temperature: ${weather['current']['temp_c']} °C / ${weather['current']['temp_f']} °F',
                                    ),
                                    Text(
                                      'Condition: ${weather['current']['condition']['text']}',
                                    ),
                                    CachedNetworkImage(
                                      imageUrl:
                                          'https:${weather['current']['condition']['icon']}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

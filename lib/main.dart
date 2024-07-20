import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_screen.dart';
import 'weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> savedCities = prefs.getStringList('savedCities') ?? ['Paris'];
  runApp(MyApp(savedCities: savedCities));
}

class MyApp extends StatelessWidget {
  final List<String> savedCities;

  const MyApp({required this.savedCities, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider(savedCities)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WeatherScreen(),
      ),
    );
  }
}

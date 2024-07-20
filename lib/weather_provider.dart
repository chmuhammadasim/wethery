import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  List<String> _savedCities;
  Map<String, dynamic> _weatherData = {};
  String? _errorMessage;
  bool _isLoading = false;

  WeatherProvider(this._savedCities) {
    fetchWeatherForSavedCities();
  }

  List<String> get savedCities => _savedCities;
  Map<String, dynamic> get weatherData => _weatherData;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchWeatherForCity(String city) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await WeatherService.fetchWeather(city);
      _weatherData[city] = data;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWeatherForSavedCities() async {
    for (String city in _savedCities) {
      await fetchWeatherForCity(city);
    }
  }

  Future<void> addCity(String city) async {
    _savedCities.add(city);
    await fetchWeatherForCity(city);
    _saveCitiesToPrefs();
    notifyListeners();
  }

  Future<void> removeCity(String city) async {
    _savedCities.remove(city);
    _weatherData.remove(city);
    _saveCitiesToPrefs();
    notifyListeners();
  }

  Future<void> _saveCitiesToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedCities', _savedCities);
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/weather_provider.dart';
import 'package:weather_app/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WeatherProvider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial state is correct', () {
      final provider = WeatherProvider(['Paris']);
      expect(provider.savedCities, ['Paris']);
      expect(provider.weatherData.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
    });

    test('Fetch weather for a city', () async {
      final provider = WeatherProvider([]);
      await provider.fetchWeatherForCity('Paris');
      expect(provider.weatherData.containsKey('Paris'), true);
      expect(provider.errorMessage, null);
    });

    test('Add and remove city', () async {
      final provider = WeatherProvider([]);
      await provider.addCity('Paris');
      expect(provider.savedCities.contains('Paris'), true);

      await provider.removeCity('Paris');
      expect(provider.savedCities.contains('Paris'), false);
    });
  });
}

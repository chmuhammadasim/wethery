# Weather App

## Overview

The Weather App is a Flutter application that provides weather information for a given city or the user's current location. The app allows users to input a city name to fetch weather data and save weather data for multiple cities. It uses the WeatherAPI to fetch current weather data and Geolocator for location services.

## Features

- **Fetch Weather by City Name**: Enter a city name to get the current weather information.
- **Fetch Weather by Current Location**: Use the device's location to get the weather information.
- **Save Weather Data**: Save weather data for multiple cities.
- **Animated UI**: Smooth transitions and animations for better user experience.
- **Error Handling**: Displays appropriate error messages when fetching data fails.
- **Offline Capabilities**: View saved weather data without an internet connection.

## Screenshots

![App Screenshot](link-to-screenshot-1)
![App Screenshot](link-to-screenshot-2)

## Installation

### Prerequisites

Ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter and Dart plugins

### Clone the Repository

Clone the repository to your local machine:
```bash
git clone https://github.com/yourusername/weatherapp.git
cd weatherapp
```

### Install Dependencies

Navigate to the project directory and install the required dependencies:
```bash
flutter pub get
```

### Run the App

To run the app on an emulator or a connected device, use:
```bash
flutter run
```

## Configuration

### API Key

Replace the `apiKey` in the `WeatherScreenState` class with your own API key from [WeatherAPI](https://www.weatherapi.com/):
```dart
final String apiKey = 'YOUR_API_KEY';
```

### Permissions

#### Android

Update `AndroidManifest.xml` to include the necessary permissions:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>

<application
    android:label="Weather App"
    android:icon="@mipmap/ic_launcher">
    <uses-library android:name="org.apache.http.legacy" android:required="false"/>
</application>
```

#### iOS

Update `Info.plist` to include the necessary permissions:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to provide weather updates.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to provide weather updates.</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Code Structure

### `main.dart`

- **Entry Point**: Sets up the application and defines the main `MyApp` widget.

### `WeatherScreen`

- **UI and Logic for Weather Data**: Handles user input for city names, fetching weather data, displaying weather information, and saving weather data.

### `fetchWeather` Method

- Fetches weather data for a given city using the WeatherAPI.

### `fetchWeatherByLocation` Method

- Fetches weather data for the current location using Geolocator to get the device's coordinates.

### `AnimationController`

- Manages animations for smooth transitions when displaying weather data.

## Dependencies

- [http](https://pub.dev/packages/http): For making HTTP requests to the WeatherAPI.
- [geolocator](https://pub.dev/packages/geolocator): For accessing device location.
- [flutter](https://flutter.dev): The framework for building the app.

## Usage

1. **Fetch Weather by City**: Enter a city name and tap the "Get Weather" button to fetch and display the weather information.
2. **Fetch Weather by Location**: Tap the location icon in the app bar to fetch and display weather information based on the current location.
3. **Save Weather Data**: Tap the save icon in the app bar to save the current weather data. The saved data will be displayed below the current weather information.

## Contributing

We welcome contributions to improve the app. To contribute:

1. **Fork the Repository**: Create your own copy of the project.
2. **Create a Branch**: Work on a new feature or bug fix in a separate branch.
3. **Submit a Pull Request**: Submit a pull request with a description of your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions, issues, or suggestions, please open an issue on the GitHub repository or contact me at [muhammadasimchattha@gmail.com](mailto:muhammadasimchattha@gmail.com).

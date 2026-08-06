import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'weather_provider.dart';
import 'weather_state.dart';

final weatherNotifierProvider = NotifierProvider<WeatherNotifier, WeatherState>(
  WeatherNotifier.new,
);

class WeatherNotifier extends Notifier<WeatherState> {
  // Flag to track if the current data is from GPS
  bool _isGpsLocation = true;

  @override
  WeatherState build() {
    // Automatically fetch current location weather as soon as the app opens
    Future.microtask(() => getCurrentLocationWeather());
    return const WeatherState();
  }

  Future<void> searchCity(String city) async {
    state = state.copyWith(isLoading: true, error: null);
    _isGpsLocation = false; // Mark as searched city

    try {
      final weather = await ref
          .read(weatherRepositoryProvider)
          .getWeatherByCity(city);

      await ref.read(localStorageProvider).saveLastCity(city);

      // Update state with the newly fetched weather data
      state = WeatherState(weather: weather);
    } catch (e) {
      state = WeatherState(error: e.toString());
    }
  }

  Future<void> loadLastCity() async {
    final city = await ref.read(localStorageProvider).getLastCity();

    if (city != null && city.isNotEmpty) {
      await searchCity(city);
    } else {
      // If there's no saved city in local storage, load the current location weather
      await getCurrentLocationWeather();
    }
  }

  Future<void> getCurrentLocationWeather() async {
    state = state.copyWith(isLoading: true, error: null);
    _isGpsLocation = true; // Mark as GPS location

    try {
      final position = await ref
          .read(locationServiceProvider)
          .getCurrentPosition();

      final weather = await ref
          .read(weatherRepositoryProvider)
          .getWeatherByLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          );

      // Update state with the newly fetched weather data
      state = WeatherState(weather: weather);
    } catch (e) {
      state = WeatherState(error: e.toString());
    }
  }

  // Smart refresh method to handle pull-to-refresh correctly
  Future<void> refreshWeather() async {
    if (_isGpsLocation) {
      // If the current data is from GPS, fetch via GPS coordinates again
      await getCurrentLocationWeather();
    } else if (state.weather != null) {
      // If it was a searched city, search again by its name
      await searchCity(state.weather!.location.name);
    }
  }
}
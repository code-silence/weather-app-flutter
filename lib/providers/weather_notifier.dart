import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'weather_provider.dart';
import 'weather_state.dart';

final weatherNotifierProvider = NotifierProvider<WeatherNotifier, WeatherState>(
  WeatherNotifier.new,
);

class WeatherNotifier extends Notifier<WeatherState> {
  @override
  WeatherState build() {
    return const WeatherState();
  }

  Future<void> searchCity(String city) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final weather = await ref
          .read(weatherRepositoryProvider)
          .getWeatherByCity(city);

      await ref.read(localStorageProvider).saveLastCity(city);

      state = WeatherState(weather: weather);
    } catch (e) {
      state = WeatherState(error: e.toString());
    }
  }

  Future<void> loadLastCity() async {
    final city = await ref.read(localStorageProvider).getLastCity();

    if (city != null && city.isNotEmpty) {
      await searchCity(city);
    }
  }

  Future<void> getCurrentLocationWeather() async {
    state = state.copyWith(isLoading: true, error: null);

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

      state = WeatherState(weather: weather);
    } catch (e) {
      state = WeatherState(error: e.toString());
    }
  }
}

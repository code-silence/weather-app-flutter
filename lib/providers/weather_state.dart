import '../models/weather_data_model.dart';

class WeatherState {
  const WeatherState({
    this.weather,
    this.isLoading = false,
    this.error,
  });

  final WeatherDataModel? weather;
  final bool isLoading;
  final String? error;

  WeatherState copyWith({
    WeatherDataModel? weather,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
import 'daily_weather_model.dart';
import 'hourly_weather_model.dart';
import 'location_model.dart';
import 'weather_model.dart';

class WeatherDataModel {
  const WeatherDataModel({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final LocationModel location;
  final WeatherModel current;
  final List<HourlyWeatherModel> hourly;
  final List<DailyWeatherModel> daily;
}
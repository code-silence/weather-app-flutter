import '../utils/weather_code_mapper.dart';
import 'package:flutter/material.dart';
import '../utils/weather_icon_mapper.dart';
class DailyWeatherModel {
  String get description => WeatherCodeMapper.description(weatherCode);
  IconData get icon =>
    WeatherIconMapper.icon(weatherCode, isDay: true);
  const DailyWeatherModel({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCode,
    required this.sunrise,
    required this.sunset,
    required this.precipitationProbability,
  });

  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int weatherCode;
  final DateTime sunrise;
  final DateTime sunset;
  final int precipitationProbability;

  factory DailyWeatherModel.fromApi({
    required int index,
    required Map<String, dynamic> daily,
  }) {
    return DailyWeatherModel(
      date: DateTime.parse(daily['time'][index]),
      maxTemperature:
          (daily['temperature_2m_max'][index] as num).toDouble(),
      minTemperature:
          (daily['temperature_2m_min'][index] as num).toDouble(),
      weatherCode: daily['weather_code'][index] as int,
      sunrise: DateTime.parse(daily['sunrise'][index]),
      sunset: DateTime.parse(daily['sunset'][index]),
      precipitationProbability:
          daily['precipitation_probability_max'][index] as int,
    );
  }
}
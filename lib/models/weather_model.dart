import 'package:flutter/material.dart';

import '../utils/weather_code_mapper.dart';
import '../utils/weather_icon_mapper.dart';

class WeatherModel {
  const WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.apparentTemperature,
    required this.isDay,
  });

  final double temperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final double apparentTemperature;
  final bool isDay;

  String get description => WeatherCodeMapper.description(weatherCode);

  IconData get icon =>
      WeatherIconMapper.icon(weatherCode, isDay: isDay);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidity: json['relative_humidity_2m'] as int,
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: json['weather_code'] as int,
      apparentTemperature:
          (json['apparent_temperature'] as num).toDouble(),
      isDay: (json['is_day'] as int) == 1,
    );
  }
}
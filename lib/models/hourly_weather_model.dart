import 'package:flutter/material.dart';

import '../utils/weather_code_mapper.dart';
import '../utils/weather_icon_mapper.dart';

class HourlyWeatherModel {
  const HourlyWeatherModel({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,

  });

  final DateTime time;
  final double temperature;
  final int humidity;
  final int weatherCode;
  final double windSpeed;

  String get description => WeatherCodeMapper.description(weatherCode);

  IconData get icon =>
      WeatherIconMapper.icon(weatherCode, isDay: true);

  factory HourlyWeatherModel.fromApi({
    required int index,
    required Map<String, dynamic> hourly,
  }) {
    return HourlyWeatherModel(
      time: DateTime.parse(hourly['time'][index]),
      temperature: (hourly['temperature_2m'][index] as num).toDouble(),
      humidity: hourly['relative_humidity_2m'][index] as int,
      weatherCode: hourly['weather_code'][index] as int,
      windSpeed: (hourly['wind_speed_10m'][index] as num).toDouble(),
    );
  }
}
import 'package:dio/dio.dart';

import '../utils/dio_client.dart';

class WeatherService {
  WeatherService() : _dio = DioClient.weather();

  final Dio _dio;

  Future<Map<String, dynamic>> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,

        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,is_day',

        'hourly':
            'time,temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,precipitation_probability,is_day',

        'daily':
            'time,weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max',

        'forecast_days': 7,
        'timezone': 'auto',
      },
    );

    return response.data!;
  }
}
import 'package:dio/dio.dart';

import '../exceptions/app_exception.dart';
import '../models/daily_weather_model.dart';
import '../models/hourly_weather_model.dart';
import '../models/location_model.dart';
import '../models/weather_data_model.dart';
import '../models/weather_model.dart';
import '../services/geocoding_service.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  WeatherRepository({
    required WeatherService weatherService,
    required GeocodingService geocodingService,
  }) : _weatherService = weatherService,
       _geocodingService = geocodingService;

  final WeatherService _weatherService;
  final GeocodingService _geocodingService;

  Future<WeatherDataModel> getWeatherByCity(String city) async {
    try {
      final locationJson = await _geocodingService.searchCity(city);

      if (locationJson['results'] == null ||
          (locationJson['results'] as List).isEmpty) {
        throw const AppException('City not found.');
      }

      final location = LocationModel.fromJson(locationJson['results'][0]);

      return getWeatherByLocation(
        latitude: location.latitude,
        longitude: location.longitude,
        location: location,
      );
    } on DioException {
      throw const AppException('Unable to connect to server.');
    }
  }

  Future<WeatherDataModel> getWeatherByLocation({
    required double latitude,
    required double longitude,
    LocationModel? location,
  }) async {
    try {
      final json = await _weatherService.getWeather(
        latitude: latitude,
        longitude: longitude,
      );

      final current = WeatherModel.fromJson(json['current']);

      final hourlyJson = json['hourly'] as Map<String, dynamic>;
      final dailyJson = json['daily'] as Map<String, dynamic>;

      final hourly = List<HourlyWeatherModel>.generate(
        (hourlyJson['time'] as List).length,
        (index) => HourlyWeatherModel.fromApi(index: index, hourly: hourlyJson),
      );

      final daily = List<DailyWeatherModel>.generate(
        (dailyJson['time'] as List).length,
        (index) => DailyWeatherModel.fromApi(index: index, daily: dailyJson),
      );

      LocationModel finalLocation;

if (location != null) {
  finalLocation = location;
} else {
  final reverseJson = await _geocodingService.reverseGeocode(
    latitude: latitude,
    longitude: longitude,
  );

  final address = reverseJson['address'] as Map<String, dynamic>;

  finalLocation = LocationModel(
    name: (address['city'] ??
            address['town'] ??
            address['village'] ??
            address['municipality'] ??
            '')
        .toString(),
    country: (address['country'] ?? '').toString(),
    latitude: latitude,
    longitude: longitude,
  );
}

        

      return WeatherDataModel(
        location: finalLocation,
        current: current,
        hourly: hourly,
        daily: daily,
      );
    } on DioException catch (e) {
      throw AppException(e.message ?? 'Unable to fetch weather.');
    } catch (e, stackTrace) {
      print('========== REPOSITORY ERROR ==========');
      print(e);
      print(stackTrace);
      rethrow;
    }
  }
}

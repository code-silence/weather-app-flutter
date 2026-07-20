import 'package:dio/dio.dart';

import '../utils/dio_client.dart';

class GeocodingService {
  GeocodingService() : _dio = DioClient.geocoding();

  final Dio _dio;

  Future<Map<String, dynamic>> searchCity(String city) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/search',
      queryParameters: {'name': city, 'count': 1},
    );

    return response.data!;
  }

  Future<Map<String, dynamic>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/reverse',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'count': 1,
      },
    );

    return response.data!;
  }
}

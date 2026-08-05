import 'package:dio/dio.dart';

import '../utils/dio_client.dart';

class GeocodingService {
  GeocodingService()
    : _dio = DioClient.geocoding(),
      _reverseDio = DioClient.nominatim();

  final Dio _dio;
  final Dio _reverseDio;

  Future<Map<String, dynamic>> searchCity(String city) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search',
        queryParameters: {'name': city, 'count': 1},
      );

      return response.data!;
    } on DioException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _reverseDio.get<Map<String, dynamic>>(
      '/reverse',
      queryParameters: {'lat': latitude, 'lon': longitude, 'format': 'jsonv2'},
    );

    return response.data!;
  }
}

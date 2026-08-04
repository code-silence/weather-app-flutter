import 'package:dio/dio.dart';

import '../utils/dio_client.dart';

class GeocodingService {
  GeocodingService() : _dio = DioClient.geocoding();

  final Dio _dio;

  Future<Map<String, dynamic>> searchCity(String city) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search',
        queryParameters: {
          'name': city,
          'count': 1,
        },
      );

      print('========== SUCCESS ==========');
      print(response.requestOptions.uri);
      print(response.data);

      return response.data!;
    } on DioException catch (e) {
      print('========== DIO ERROR ==========');
      print('URL: ${e.requestOptions.uri}');
      print('Status Code: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('========== UNKNOWN ERROR ==========');
      print(e);
      rethrow;
    }
  }
}
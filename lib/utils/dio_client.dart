import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'constants.dart';

class DioClient {
  const DioClient._();

  static Dio weather() {
    return Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.weatherBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        responseType: ResponseType.json,
      ),
    );
  }

  static Dio geocoding() {
    return Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.geocodingBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        responseType: ResponseType.json,
      ),
    );
  }

  static Dio nominatim() {
  return Dio(
    BaseOptions(
      baseUrl: 'https://nominatim.openstreetmap.org',
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      responseType: ResponseType.json,
      headers: {
        'User-Agent': 'weather_app_flutter',
      },
    ),
  );
}


}
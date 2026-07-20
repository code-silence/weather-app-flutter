import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/weather_repository.dart';
import '../services/geocoding_service.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/local_storage_service.dart';

final weatherServiceProvider = Provider<WeatherService>(
  (ref) => WeatherService(),
);

final geocodingServiceProvider = Provider<GeocodingService>(
  (ref) => GeocodingService(),
);

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

final localStorageProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(
    weatherService: ref.read(weatherServiceProvider),
    geocodingService: ref.read(geocodingServiceProvider),
  ),
);
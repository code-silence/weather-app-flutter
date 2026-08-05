import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import '../providers/weather_notifier.dart';

// Widgets
import '../widgets/current_weather_view.dart';
import '../widgets/hourly_forecast_view.dart';
import '../widgets/daily_forecast_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optional: Fetch weather for the current location when the app starts
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(weatherNotifierProvider.notifier).getCurrentLocationWeather();
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              ref.read(weatherNotifierProvider.notifier).getCurrentLocationWeather();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter city name (e.g., Dhaka)...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    ref.read(weatherNotifierProvider.notifier).searchCity(value.trim());
                  }
                },
              ),
              const SizedBox(height: 20),

              // Main Content Area (Loading, Error, or Weather Data)
              Expanded(
                child: _buildContent(weatherState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to keep the build function clean
  Widget _buildContent(dynamic weatherState) {
    if (weatherState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (weatherState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            weatherState.error!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (weatherState.weather == null) {
      return const Center(
        child: Text('Search for a city or tap the location icon'),
      );
    }

    final weather = weatherState.weather!;

    return ListView(
      children: [
        CurrentWeatherView(weather: weather),
        const SizedBox(height: 24),
        HourlyForecastView(hourly: weather.hourly),
        const SizedBox(height: 24),
        DailyForecastView(daily: weather.daily),
      ],
    );
  }
}
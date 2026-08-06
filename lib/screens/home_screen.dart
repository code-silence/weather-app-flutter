import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import '../providers/weather_notifier.dart';
// Models
import '../models/weather_data_model.dart';

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
  
  // State variable to control the manual refresh animation
  bool _isManualRefreshing = false; 

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper method to determine the background gradient based on weather condition
  LinearGradient _getBackgroundGradient(WeatherDataModel? weather) {
    if (weather == null) {
      // Default Sky Blue gradient for loading or initial state
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF56CCF2), Color(0xFFE0F2FE)],
      );
    }

    final String condition = weather.current.description.toLowerCase();

    if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunder')) {
      // Rainy weather: Soft Blue-Grey gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9BAFD9), Color(0xFFE0E8F5)],
      );
    } else if (condition.contains('cloud') || condition.contains('overcast') || condition.contains('fog')) {
      // Cloudy weather: Soft Greyish gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFCFD9DF), Color(0xFFE2EBF0)],
      );
    } else if (condition.contains('snow')) {
      // Snowy weather: Frosty White gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE2E2E2), Color(0xFFFFFFFF)],
      );
    } else {
      // Clear/Sunny weather: Vibrant Sky Blue
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF56CCF2), Color(0xFFE0F2FE)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);

    return AnimatedContainer(
      duration: const Duration(seconds: 1), // Smooth transition between colors
      decoration: BoxDecoration(
        // The gradient will change dynamically based on the current weather
        gradient: _getBackgroundGradient(weatherState.weather),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Weather App',
            style: TextStyle(
              color: Colors.blueGrey.shade900, 
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.my_location, color: Colors.blueGrey.shade900),
              onPressed: () {
                ref.read(weatherNotifierProvider.notifier).getCurrentLocationWeather();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1), // Reduced shadow slightly for cleaner look
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Enter city name (e.g., Dhaka)...',
                      hintStyle: const TextStyle(color: Colors.black45),
                      prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.95),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        ref.read(weatherNotifierProvider.notifier).searchCity(value.trim());
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 25),

                // Main Content Area
                Expanded(
                  child: _buildContent(weatherState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(dynamic weatherState) {
    if (weatherState.isLoading && weatherState.weather == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blueAccent),
            SizedBox(height: 16),
            Text(
              'Fetching Weather...',
              style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    if (weatherState.error != null && weatherState.weather == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              weatherState.error!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (weatherState.weather == null) {
      return const Center(
        child: Text(
          'Search for a city or tap the location icon',
          style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    final weather = weatherState.weather!;

    return RefreshIndicator(
      color: Colors.blueAccent,
      backgroundColor: Colors.white,
      onRefresh: () async {
        setState(() {
          _isManualRefreshing = true;
        });

        if (weather.location.name.isNotEmpty) {
          ref.read(weatherNotifierProvider.notifier).searchCity(weather.location.name);
        } else {
          ref.read(weatherNotifierProvider.notifier).getCurrentLocationWeather();
        }
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (context.mounted) {
          setState(() {
            _isManualRefreshing = false;
          });
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: (_isManualRefreshing || weatherState.isLoading)
                ? _buildSkeletonLoading()
                : Column(
                    key: const ValueKey('data'),
                    children: [
                      CurrentWeatherView(weather: weather),
                      const SizedBox(height: 30),
                      HourlyForecastView(hourly: weather.hourly),
                      const SizedBox(height: 30),
                      DailyForecastView(daily: weather.daily),
                      const SizedBox(height: 20),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Column(
      key: const ValueKey('loading'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 24,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 24,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
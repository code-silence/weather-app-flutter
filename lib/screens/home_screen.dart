import 'dart:ui'; // Imported for the blur effect (Glassmorphism)
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
  final FocusNode _searchFocusNode = FocusNode(); // Added FocusNode to control keyboard smoothly
  
  bool _isManualRefreshing = false; 
  bool _isSearchExpanded = false; 

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // Dispose the FocusNode to prevent memory leaks
    super.dispose();
  }

  // Helper method to determine the background gradient based on weather condition
  LinearGradient _getBackgroundGradient(WeatherDataModel? weather) {
    if (weather == null) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF56CCF2), Color(0xFFE0F2FE)],
      );
    }

    final String condition = weather.current.description.toLowerCase();

    if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunder')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9BAFD9), Color(0xFFE0E8F5)],
      );
    } else if (condition.contains('cloud') || condition.contains('overcast') || condition.contains('fog')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFCFD9DF), Color(0xFFE2EBF0)],
      );
    } else if (condition.contains('snow')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE2E2E2), Color(0xFFFFFFFF)],
      );
    } else {
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
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(seconds: 1), 
      decoration: BoxDecoration(
        gradient: _getBackgroundGradient(weatherState.weather),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'SkyCast',
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
          child: Stack(
            children: [
              // 1. Main Content (Scrolls beneath the search bar)
              Positioned.fill(
                child: _buildContent(weatherState),
              ),

              // 2. Floating Glassmorphism Search Bar
              Positioned(
                top: 5,
                left: 16,
                right: 16,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), 
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), 
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: _isSearchExpanded ? screenWidth - 32 : 40, 
                        height: 40, 
                        decoration: BoxDecoration(
                          color: _isSearchExpanded 
                              ? Colors.white.withOpacity(0.95) 
                              : Colors.white.withOpacity(0.35), 
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5), 
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSearchExpanded = !_isSearchExpanded;
                                  if (!_isSearchExpanded) {
                                    // Close search and hide keyboard
                                    _searchController.clear();
                                    _searchFocusNode.unfocus(); 
                                  } else {
                                    // Delay keyboard slightly so the animation can finish smoothly
                                    Future.delayed(const Duration(milliseconds: 150), () {
                                      if (mounted) {
                                        _searchFocusNode.requestFocus();
                                      }
                                    });
                                  }
                                });
                              },
                              child: Container(
                                width: 38, 
                                height: 38, 
                                color: Colors.transparent,
                                child: Icon(
                                  _isSearchExpanded ? Icons.close : Icons.search,
                                  color: Colors.blueGrey.shade900,
                                  size: 20, 
                                ),
                              ),
                            ),
                            
                            if (_isSearchExpanded)
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode, // Controlled by FocusNode instead of autofocus
                                  textAlignVertical: TextAlignVertical.center, 
                                  style: const TextStyle(color: Colors.black87, fontSize: 15), 
                                  decoration: const InputDecoration(
                                    isDense: true, 
                                    hintText: 'Enter city name...',
                                    hintStyle: TextStyle(color: Colors.black45),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(right: 16), 
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      ref.read(weatherNotifierProvider.notifier).searchCity(value.trim());
                                      _searchController.clear();
                                      _searchFocusNode.unfocus(); // Hide keyboard properly
                                      setState(() {
                                        _isSearchExpanded = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(dynamic weatherState) {
    if (weatherState.isLoading && weatherState.weather == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 60.0), 
        child: Center(
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
        ),
      );
    }

    if (weatherState.error != null && weatherState.weather == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0), 
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
      return const Padding(
        padding: EdgeInsets.only(top: 60.0), 
        child: Center(
          child: Text(
            'Search for a city or tap the location icon',
            style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
          ),
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

        await ref.read(weatherNotifierProvider.notifier).refreshWeather();
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (context.mounted) {
          setState(() {
            _isManualRefreshing = false;
          });
        }
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0, bottom: 20.0), 
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
        Container(
          height: 24,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
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
        Container(
          height: 24,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
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
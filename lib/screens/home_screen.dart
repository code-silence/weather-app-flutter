import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_notifier.dart';

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
        child: Text(
          weatherState.error!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
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
        // Location Header
        // Location Header
        Text(
          weather.location.name.isNotEmpty 
              ? '${weather.location.name}${weather.location.country.isNotEmpty ? ', ${weather.location.country}' : ''}'
              : 'My Location', // Fallback text when name is empty
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Current Temperature
        Center(
          child: Text(
            '${weather.current.temperature}°C',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        
        // Weather Description
        Center(
          child: Text(
            weather.current.description,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),

        // Extra Info Card (Humidity & Wind)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue),
                    const SizedBox(height: 5),
                    const Text('Humidity'),
                    Text('${weather.current.humidity}%'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.air, color: Colors.teal),
                    const SizedBox(height: 5),
                    const Text('Wind Speed'),
                    Text('${weather.current.windSpeed} km/h'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        
        // Hourly Forecast Section
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hourly Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Limit the list to maximum 24 items
            itemCount: weather.hourly.length > 24 ? 24 : weather.hourly.length,
            itemBuilder: (context, index) {
              final hourlyData = weather.hourly[index];
              return Card(
                margin: const EdgeInsets.only(right: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${hourlyData.time.hour}:00'),
                      const SizedBox(height: 8),
                      Icon(hourlyData.icon, size: 30),
                      const SizedBox(height: 8),
                      Text('${hourlyData.temperature}°C'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Daily Forecast Section
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '7-Day Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weather.daily.length,
          itemBuilder: (context, index) {
            final dailyData = weather.daily[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(dailyData.icon, size: 30),
              title: Text('${dailyData.date.day}/${dailyData.date.month}'),
              subtitle: Text(dailyData.description),
              trailing: Text(
                '${dailyData.minTemperature}° / ${dailyData.maxTemperature}°',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}
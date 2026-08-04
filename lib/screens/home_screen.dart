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
    // অ্যাপ চালু হওয়ার সাথে সাথে জিপিএস লোকেশন বা ডিফল্ট কোনো শহরের আবহাওয়া লোড করতে পারো
    // যেমন: ref.read(weatherNotifierProvider.notifier).getCurrentLocationWeather();
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
              // জিপিএস লোকেশন থেকে ওয়েদার আনার ফাংশন
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
              // সার্চ বার
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

              // লোডিং, এরর বা ডেটা শো করার লজিক
              Expanded(
                child: weatherState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : weatherState.error != null
                        ? Center(
                            child: Text(
                              weatherState.error!,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : weatherState.weather == null
                            ? const Center(
                                child: Text('Search for the city name or tap the location icon'),
                              )
                            : ListView(
                                children: [
                                  // শহরের নাম ও দেশ
                                  Text(
                                    '${weatherState.weather!.location.name}, ${weatherState.weather!.location.country}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),

                                  // বর্তমান তাপমাত্রা
                                  Center(
                                    child: Text(
                                      '${weatherState.weather!.current.temperature}°C',
                                      style: const TextStyle(
                                        fontSize: 64,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  
                                  // আবহাওয়ার বিবরণ (Description)
                                  Center(
                                    child: Text(
                                      weatherState.weather!.current.description,
                                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // অতিরিক্ত তথ্য (আর্দ্রতা ও বাতাসের গতি)
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
                                              const Text('আর্দ্রতা'),
                                              Text('${weatherState.weather!.current.humidity}%'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Icon(Icons.air, color: Colors.teal),
                                              const SizedBox(height: 5),
                                              const Text('বাতাসের গতি'),
                                              Text('${weatherState.weather!.current.windSpeed} km/h'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
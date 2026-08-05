import 'package:flutter/material.dart';
import '../models/hourly_weather_model.dart';

class HourlyForecastView extends StatelessWidget {
  final List<HourlyWeatherModel> hourly;

  const HourlyForecastView({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hourly Forecast',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length > 24 ? 24 : hourly.length,
            itemBuilder: (context, index) {
              final data = hourly[index];
              
              return Card(
                margin: const EdgeInsets.only(right: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reverted back to the original 24-hour format
                      Text('${data.time.hour}:00'),
                      const SizedBox(height: 8),
                      Icon(data.icon, size: 30),
                      const SizedBox(height: 8),
                      Text('${data.temperature}°C'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
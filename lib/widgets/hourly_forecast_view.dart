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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Hourly Forecast',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w800,
              color: Colors.blueGrey.shade900,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 130,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length > 24 ? 24 : hourly.length,
            itemBuilder: (context, index) {
              final data = hourly[index];
              
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4), // Glass effect
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${data.time.hour}:00',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                      ),
                      const Spacer(),
                      Icon(data.icon, size: 30, color: Colors.blueGrey.shade800),
                      const Spacer(),
                      Text(
                        '${data.temperature}°C',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
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
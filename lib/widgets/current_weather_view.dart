import 'package:flutter/material.dart';
import '../models/weather_data_model.dart';

class CurrentWeatherView extends StatelessWidget {
  final WeatherDataModel weather;

  const CurrentWeatherView({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Location Header
        Text(
          weather.location.name.isNotEmpty 
              ? '${weather.location.name}${weather.location.country.isNotEmpty ? ', ${weather.location.country}' : ''}'
              : 'My Location', 
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
      ],
    );
  }
}
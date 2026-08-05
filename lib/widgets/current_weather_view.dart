import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_data_model.dart';

class CurrentWeatherView extends StatelessWidget {
  final WeatherDataModel weather;

  const CurrentWeatherView({super.key, required this.weather});

  // Updated Lottie Links (Using LottieFiles public URLs)
  String _getWeatherAnimation(String condition) {
    final cond = condition.toLowerCase();
    
    if (cond.contains('rain') || cond.contains('drizzle')) {
      return 'https://assets2.lottiefiles.com/packages/lf20_J6tZNg.json'; // Rain
    } else if (cond.contains('thunder') || cond.contains('storm')) {
      return 'https://assets2.lottiefiles.com/packages/lf20_XbZZJz.json'; // Thunder
    } else if (cond.contains('cloud') || cond.contains('overcast') || cond.contains('fog')) {
      return 'https://assets2.lottiefiles.com/packages/lf20_krtpzsmo.json'; // Cloud
    } else if (cond.contains('snow')) {
      return 'https://assets2.lottiefiles.com/packages/lf20_rhbjwz.json'; // Snow
    } else {
      return 'https://assets2.lottiefiles.com/packages/lf20_xlkxcgws.json'; // Sunny
    }
  }

  // Smart Fallback Icon if Lottie fails to load
  IconData _getFallbackIcon(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains('rain') || cond.contains('drizzle')) return Icons.water_drop;
    if (cond.contains('thunder') || cond.contains('storm')) return Icons.flash_on;
    if (cond.contains('cloud') || cond.contains('overcast') || cond.contains('fog')) return Icons.cloud;
    if (cond.contains('snow')) return Icons.ac_unit;
    return Icons.wb_sunny;
  }

  // Smart Fallback Color
  Color _getFallbackColor(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains('rain') || cond.contains('drizzle')) return Colors.blue.shade700;
    if (cond.contains('thunder') || cond.contains('storm')) return Colors.deepPurple;
    if (cond.contains('cloud') || cond.contains('overcast') || cond.contains('fog')) return Colors.blueGrey;
    if (cond.contains('snow')) return Colors.lightBlue;
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Location Header
        Text(
          weather.location.name.isNotEmpty 
              ? '${weather.location.name}${weather.location.country.isNotEmpty ? ', ${weather.location.country}' : ''}'
              : 'My Location', 
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey.shade900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Weather Description
        Text(
          weather.current.description,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        // Dynamic Lottie Weather Animation with Smart Fallback
        SizedBox(
          height: 180,
          width: 180,
          child: Lottie.network(
            _getWeatherAnimation(weather.current.description),
            fit: BoxFit.contain,
            // If the Lottie URL is broken or internet is slow, show a beautiful material icon instead
            errorBuilder: (context, error, stackTrace) => Icon(
              _getFallbackIcon(weather.current.description),
              size: 100,
              color: _getFallbackColor(weather.current.description),
            ),
          ),
        ),

        // Current Temperature
        Text(
          '${weather.current.temperature}°C',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w300,
            color: Colors.blueGrey.shade900,
          ),
        ),
        const SizedBox(height: 30),

        // Extra Info Container (Glass Effect)
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4), // Semi-transparent
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(Icons.water_drop, Colors.blue.shade700, 'Humidity', '${weather.current.humidity}%'),
              _buildInfoItem(Icons.air, Colors.teal.shade700, 'Wind Speed', '${weather.current.windSpeed} km/h'),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for info items
  Widget _buildInfoItem(IconData icon, Color color, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
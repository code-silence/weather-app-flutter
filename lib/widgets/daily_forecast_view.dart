import 'package:flutter/material.dart';
import '../models/daily_weather_model.dart';

class DailyForecastView extends StatelessWidget {
  final List<DailyWeatherModel> daily;

  const DailyForecastView({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '7-Day Forecast',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w800,
              color: Colors.blueGrey.shade900,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4), // Glass effect container
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daily.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12, 
              height: 1, 
              indent: 16, 
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final data = daily[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                leading: Icon(data.icon, size: 32, color: Colors.blueGrey.shade800),
                title: Text(
                  '${data.date.day}/${data.date.month}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  data.description,
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: Text(
                  '${data.minTemperature}° / ${data.maxTemperature}°',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
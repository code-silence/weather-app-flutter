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
        const Text(
          '7-Day Forecast',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daily.length,
          itemBuilder: (context, index) {
            final data = daily[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(data.icon, size: 30),
              title: Text('${data.date.day}/${data.date.month}'),
              subtitle: Text(data.description),
              trailing: Text(
                '${data.minTemperature}° / ${data.maxTemperature}°',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}
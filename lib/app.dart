import 'package:flutter/material.dart';
//import 'screens/home_screen.dart'; // একটু পরে আমরা এই স্ক্রিন বানাবো

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // ফোনের থিম অনুযায়ী লাইট/ডার্ক মোড হবে
      home: const Scaffold(
        body: Center(
          child: Text('Weather App Initialization...'), // হোম স্ক্রিন বানানোর পর এটা বদলে দেব
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'screens/reward_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reward Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const RewardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

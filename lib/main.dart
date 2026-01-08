import 'package:flutter/material.dart';
// 1. GANTI IMPORT INI
import 'screens/register_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiBank UAS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003D70)),
        useMaterial3: true,
      ),

      // 2. GANTI BAGIAN INI MENJADI LOGIN SCREEN
      home: const RegisterScreen(), 
    );
  }
}
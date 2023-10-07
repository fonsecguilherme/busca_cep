import 'package:flutter/material.dart';
import 'package:zip_search/pages/welcome_page/welcome_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}

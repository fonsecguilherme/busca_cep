import 'package:flutter/material.dart';
import 'package:zip_search/data/via_cep_repository.dart';
import 'package:zip_search/pages/welcome_page/welcome_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final ViaCepRepository viaCepRepository = ViaCepRepository();

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

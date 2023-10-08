import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/commons/shared_preferences_keys.dart';
import 'package:zip_search/pages/root_page/root_page.dart';
import 'package:zip_search/pages/welcome_page/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  var isFirstExecution = prefs.getBool(SharedPreferencesKeys.boolKey) ?? true;

  runApp(MainApp(
    prefs: prefs,
    isFirstExecution: isFirstExecution,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.prefs,
    required this.isFirstExecution,
  });

  final SharedPreferences prefs;

  final bool isFirstExecution;

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
      home: isFirstExecution
          ? WelcomePage(
              prefs: prefs,
            )
          : const RootPage(),
    );
  }
}

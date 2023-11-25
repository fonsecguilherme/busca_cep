import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/app.dart';
import 'package:zip_search/commons/shared_preferences_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  var isFirstExecution = prefs.getBool(SharedPreferencesKeys.boolKey) ?? true;

  runApp(
    MyApp(
      prefs: prefs,
      isFirstExecution: isFirstExecution,
    ),
  );
}

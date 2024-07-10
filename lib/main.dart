import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/app.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var prefs = await SharedPreferences.getInstance();
  var isFirstExecution = prefs.getBool(SharedPreferencesKeys.boolKey) ?? true;

  runApp(
    MyApp(
      prefs: prefs,
      isFirstExecution: isFirstExecution,
    ),
  );
}

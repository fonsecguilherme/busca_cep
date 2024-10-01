import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zip_search/app.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/firebase_options.dart';

import 'core/di/setup_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setup();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = getIt<SharedServices>();

  final isFirstExecution =
      await prefs.getBool(SharedPreferencesKeys.boolKey) ?? true;

  runApp(
    MyApp(
      prefs: prefs,
      isFirstExecution: isFirstExecution,
    ),
  );
}

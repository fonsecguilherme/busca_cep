import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/navigation_page/navigation_page.dart';
import 'package:zip_search/core/features/welcome_page/welcome_page.dart';
import 'package:zip_search/data/shared_services.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool isFirstExecution;

  const MyApp({
    required this.prefs,
    required this.isFirstExecution,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sharedServices = SharedServices();

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
          : BlocProvider(
              create: (context) => FavoritesCubit(
                sharedServices: sharedServices,
              ),
              child: const NavigationPage(),
            ),
    );
  }
}

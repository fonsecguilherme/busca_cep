import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/navigation_page/navigation_page.dart';
import 'package:zip_search/core/features/welcome_page/welcome_page.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/setup_locator.dart';

import 'core/features/theme/cubit/theme_cubit.dart';

class MyApp extends StatefulWidget {
  final SharedServices prefs;
  final bool isFirstExecution;

  const MyApp({
    required this.prefs,
    required this.isFirstExecution,
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(
            sharedServices: getIt<SharedServices>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, appTheme) {
          return MaterialApp(
            theme: appTheme.value,
            debugShowCheckedModeBanner: false,
            home: widget.isFirstExecution
                ? WelcomePage(prefs: widget.prefs)
                : const NavigationPage(),
          );
        },
      ),
    );
  }
}

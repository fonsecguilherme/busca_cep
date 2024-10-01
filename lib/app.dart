import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/presentation/navigation_page/navigation_page.dart';
import 'package:zip_search/presentation/welcome_page/welcome_page.dart';
import 'package:zip_search/data/shared_services.dart';

import 'core/di/setup_locator.dart';
import 'presentation/theme/cubit/theme_cubit.dart';

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

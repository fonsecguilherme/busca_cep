import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/navigation_page/navigation_page.dart';
import 'package:zip_search/core/features/welcome_page/welcome_page.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/via_cep_repository.dart';
import 'package:zip_search/setup_locator.dart';

class MyApp extends StatelessWidget {
  final SharedServices prefs;
  final bool isFirstExecution;

  const MyApp({
    required this.prefs,
    required this.isFirstExecution,
    super.key,
  });

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
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SharedServices>(
            create: (_) => getIt<SharedServices>(),
          ),
          RepositoryProvider<FirebaseAnalytics>(
            create: (_) => getIt<FirebaseAnalytics>(),
          ),
          RepositoryProvider<IViaCepRepository>(
            create: (_) => getIt<IViaCepRepository>(),
          )
        ],
        child: isFirstExecution
            ? WelcomePage(
                prefs: prefs,
              )
            : BlocProvider(
                create: (context) => FavoritesCubit(
                  sharedServices: getIt<SharedServices>(),
                ),
                child: const NavigationPage(),
              ),
      ),
    );
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/counter_page/counter_page.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';
import 'package:zip_search/presentation/theme/cubit/theme_cubit.dart';

import '../../firebase_mock.dart';

class MockSearchZipCubit extends MockCubit<SearchState>
    implements SearchCubit {}

class MockSharedServices extends Mock implements SharedServices {}

late SearchCubit searchZipCubit;
late SharedServices services;

void main() {
  setupFirebaseAnalyticsMocks();
  final getItTest = GetIt.instance;

  setUp(() async {
    await Firebase.initializeApp();

    searchZipCubit = MockSearchZipCubit();
    services = MockSharedServices();
    getItTest.registerLazySingleton(() => services);
    getItTest.registerLazySingleton(() => FirebaseAnalytics.instance);
  });

  tearDown(
    () {
      searchZipCubit.close();
      getItTest.reset();
    },
  );

  testWidgets('Find initial widgets', (tester) async {
    when(() => services.getInt(any())).thenAnswer((_) async => 1);

    when(() => services.getBool(any())).thenAnswer(
      (_) async => true,
    );

    await _createWidget(tester);

    expect(find.byKey(CounterPage.counterPageKey), findsOneWidget);

    expect(find.text(AppStrings.greetingsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSearchedZipsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSavedZipsText), findsOneWidget);

    expect(find.text('0'), findsWidgets);
  });

  testWidgets('Find correct counter value when a correct zip is returned',
      (tester) async {
    when(() => services.getInt(any())).thenAnswer((_) async => 1);

    when(() => services.getBool(any())).thenAnswer(
      (_) async => true,
    );

    await _createWidget(tester);

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(CounterPage.counterPageKey), findsOneWidget);

    expect(find.text(AppStrings.greetingsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSearchedZipsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSavedZipsText), findsOneWidget);

    expect(find.text('1'), findsWidgets);
  });

  testWidgets('Find correct saved counter value when a favorite zip is saved',
      (tester) async {
    when(() => services.getBool(any())).thenAnswer(
      (_) async => true,
    );

    when(() => services.getInt(SharedPreferencesKeys.savedZipKey))
        .thenAnswer((_) async => 1);

    when(() => services.getInt(SharedPreferencesKeys.counterSearchedZipsKeys))
        .thenAnswer((_) async => 2);

    when(() => searchZipCubit.state).thenReturn(
        (const FavoriteAddressState(message: 'CEP favoritado com sucesso!')));
    when(() => searchZipCubit.counterFavZips).thenReturn(1);
    when(() => searchZipCubit.counterSearchedZips).thenReturn(2);

    await _createWidget(tester);

    expect(find.byKey(CounterPage.counterPageKey), findsOneWidget);

    expect(find.text(AppStrings.greetingsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSearchedZipsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSavedZipsText), findsOneWidget);

    await tester.pump();

    await tester.pumpAndSettle();

    expect(find.text('${searchZipCubit.counterFavZips}'), findsOneWidget);
    expect(find.text('${searchZipCubit.counterSearchedZips}'), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => searchZipCubit,
          ),
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
          )
        ],
        child: const CounterPage(),
      ),
    ),
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/analytics_events.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/presentation/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/presentation/search_page/widgets/add_favorites_button.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/via_cep_repository.dart';

import '../../../firebase_mock.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

class MockSharedServices extends Mock implements SharedServices {}

class MockViaCepRepository extends Mock implements ViaCepRepository {}

class MockTracker extends Mock implements FirebaseAnalytics {}

late FavoritesCubit favoritesCubit;
late SearchZipCubit searchZipCubit;
late FirebaseAnalytics analytics;
late SharedServices services;
late ViaCepRepository repository;

void main() {
  setupFirebaseAnalyticsMocks();

  setUp(() async {
    await Firebase.initializeApp();

    favoritesCubit = MockFavoritesCubit();
    searchZipCubit = MockSearchZipCubit();
    services = MockSharedServices();
    repository = MockViaCepRepository();
    analytics = MockTracker();

    registerFallbackValue(_address);
  });

  tearDown(() {
    favoritesCubit.close();
    searchZipCubit.close();
  });

  testWidgets('add favorites button ...', (tester) async {
    await _createWidget(tester);

    expect(find.text(AppStrings.addToFavoritesButton), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.star), findsOneWidget);
  });

  // TODO: verify if functions were called
  testWidgets('Find if functions were called after tap button', (tester) async {
    when(() => searchZipCubit.state)
        .thenReturn(FetchedSearchZipState(_address));

    when(() => searchZipCubit.addToFavorites(_address)).thenAnswer(
      (_) async => Future.value(),
    );

    when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
      (_) async => Future.value(),
    );

    when(
      () => analytics.logEvent(
        name: SearchPageEvents.searchPageAddFavoriteButton,
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => Future.value());

    await _createWidget(tester);

    final buttonText = find.text(AppStrings.addToFavoritesButton);

    await tester.tap(buttonText);

    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    verify(() => searchZipCubit.addToFavorites(_address)).called(1);
    verify(() => favoritesCubit.loadFavoriteAdresses()).called(1);
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
            create: (context) => favoritesCubit,
          ),
        ],
        child: AddFavoritesButton(
          address: _address,
          analytics: analytics,
        ),
      ),
    ),
  );
}

const _address = AddressModel(
  cep: '12345678',
  logradouro: 'logradouro',
  complemento: 'complemento',
  bairro: 'bairro',
  localidade: 'localidade',
  uf: 'uf',
  ddd: 'ddd',
);

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';
import 'package:zip_search/presentation/favorite_page/favorite_page.dart';

import '../../firebase_mock.dart';

class MockFavoritesCubit extends MockCubit<FavoriteState>
    implements FavoriteCubit {}

class MockSharedServices extends Mock implements SharedServices {}

late FavoriteCubit favoriteCubit;
late SharedServices services;

void main() {
  setupFirebaseAnalyticsMocks();
  final getItTest = GetIt.instance;

  setUp(() async {
    await Firebase.initializeApp();
    favoriteCubit = MockFavoritesCubit();
    services = MockSharedServices();
    getItTest.registerLazySingleton(() => FirebaseAnalytics.instance);
  });

  tearDown(() {
    favoriteCubit.close();
    getItTest.reset();
  });

  group('Page state tests', () {
    testWidgets('Find initial page', (tester) async {
      when(() => favoriteCubit.loadFavoriteAdresses()).thenAnswer(
        (_) async => Future.value(),
      );

      when(() => favoriteCubit.state).thenReturn(const InitialFavoriteState());

      await _createWidget(tester);

      expect(find.text(AppStrings.initialZipPageText), findsOneWidget);
    });

    testWidgets('Find favorited adresses', (tester) async {
      when(() => favoriteCubit.loadFavoriteAdresses()).thenAnswer(
        (_) async => Future.value(),
      );

      when(() => favoriteCubit.state)
          .thenReturn(LoadFavoriteZipState(addresses: _addressList));

      await _createWidget(tester);

      expect(
          find.byKey(FavoritePage.loadedFavoriteAdressesKey), findsOneWidget);
    });
  });

  group('Delete address', () {
    testWidgets('Check if delete address from function is called',
        (tester) async {
      when(() => favoriteCubit.loadFavoriteAdresses()).thenAnswer(
        (_) async => Future.value(),
      );

      when(() => favoriteCubit.deleteAddress(_address)).thenAnswer(
        (_) async => Future.value(),
      );
      when(() => services.getListString(SharedPreferencesKeys.savedAdresses))
          .thenAnswer(
        (_) async => any(),
      );

      when(() => favoriteCubit.state)
          .thenReturn(LoadFavoriteZipState(addresses: _addressList));

      await _createWidget(tester);

      final deleteButton = find.byIcon(CupertinoIcons.delete);

      await tester.tap(deleteButton);

      await tester.pump();

      final okButton = find.text(AppStrings.okText);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(okButton);

      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      verify(() => favoriteCubit.deleteAddress(_address)).called(1);
    });
  });

  group('Flushbar Test', () {
    testWidgets('Should show flushbar when delete an address', (tester) async {
      when(() => favoriteCubit.loadFavoriteAdresses()).thenAnswer(
        (_) async => Future.value(),
      );

      await tester.runAsync(() async {
        final state = StreamController<FavoriteState>();

        whenListen<FavoriteState>(
          favoriteCubit,
          state.stream,
          initialState: const InitialFavoriteState(),
        );

        await _createWidget(tester);

        state.add(
            const DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText));

        await tester.pump();
        await tester.pump();
        await tester.pump();

        expect(find.text(AppStrings.deletedFavoriteZipText), findsOneWidget);
      });
    });
  });
}

final _address = FavoriteModel(
  addressModel: const AddressModel(
    cep: '12345678',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
);

final _addressList = [
  FavoriteModel(
    addressModel: const AddressModel(
      cep: '12345678',
      logradouro: 'logradouro',
      complemento: 'complemento',
      bairro: 'bairro',
      localidade: 'localidade',
      uf: 'uf',
      ddd: 'ddd',
    ),
  )
];

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: favoriteCubit,
        child: const FavoritePage(),
      ),
    ),
  );
  await tester.pump();
}

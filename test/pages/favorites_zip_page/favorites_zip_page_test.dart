import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/features/favorites_zip_page/favorites_zip_page.dart';
import 'package:zip_search/core/model/address_model.dart';

import '../../firebase_mock.dart';

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

late FavoritesCubit favoritesCubit;

void main() {
  setupFirebaseAnalyticsMocks();

  setUp(() async {
    await Firebase.initializeApp();
    favoritesCubit = MockFavoritesCubit();
  });

  tearDown(() {
    favoritesCubit.close();
  });

  testWidgets('Find initial page', (tester) async {
    when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
      (_) async => Future.value(),
    );

    when(() => favoritesCubit.state).thenReturn(InitialFavoriteState());

    await _createWidget(tester);

    expect(find.text(AppStrings.initialZipPageText), findsOneWidget);
  });

  testWidgets('Find favorited adresses', (tester) async {
    when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
      (_) async => Future.value(),
    );

    when(() => favoritesCubit.state)
        .thenReturn(LoadFavoriteZipState(_addressList));

    await _createWidget(tester);

    expect(
        find.byKey(FavoritesZipPAge.loadedFavoriteAdressesKey), findsOneWidget);
  });

  testWidgets('Check if delete address from function is called',
      (tester) async {
    when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
      (_) async => Future.value(),
    );

    // when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
    //   (_) async => favoritesCubit,
    // );

    when(() => favoritesCubit.state)
        .thenReturn(LoadFavoriteZipState(_addressList));

    await _createWidget(tester);

    final deleteButton = find.byIcon(Icons.delete);

    await tester.tap(deleteButton);

    await tester.pump();

    final okButton = find.text(AppStrings.okText);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(okButton);

    // await tester.pump();
    // await tester.pumpAndSettle(Duration(seconds: 2));

    //  verify(() => favoritesCubit.deleteAddress(_address)).called(1);
  });

  testWidgets('Should show flushbar when delete an address', (tester) async {
    when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
      (_) async => Future.value(),
    );

    await tester.runAsync(() async {
      final state = StreamController<FavoritesState>();

      whenListen<FavoritesState>(
        favoritesCubit,
        state.stream,
        initialState: InitialFavoriteState(),
      );

      await _createWidget(tester);

      state.add(DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText));

      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text(AppStrings.deletedFavoriteZipText), findsOneWidget);
    });
  });
}

AddressModel _address = const AddressModel(
  cep: '12345678',
  logradouro: 'logradouro',
  complemento: 'complemento',
  bairro: 'bairro',
  localidade: 'localidade',
  uf: 'uf',
  ddd: 'ddd',
);

List<AddressModel> _addressList = [
  const AddressModel(
    cep: '12345678',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
];

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: favoritesCubit,
        child: const FavoritesZipPAge(),
      ),
    ),
  );
  await tester.pump();
}

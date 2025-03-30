import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/favorite_page/cubit/export_favorite_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';
import 'package:zip_search/presentation/search_page/search_page.dart';
import 'package:zip_search/presentation/search_page/widgets/initial_widget.dart';
import 'package:zip_search/presentation/search_page/widgets/success_widget.dart';

import '../../firebase_mock.dart';

class MockSearchZipCubit extends MockCubit<SearchState>
    implements SearchCubit {}

class MockFavoriteCubit extends MockCubit<FavoriteState>
    implements FavoriteCubit {}

class FakeAddressModel extends Fake implements AddressModel {}

late SearchCubit searchZipCubit;
late FavoriteCubit favoriteCubit;

AddressModel _addressModel = const AddressModel(
  cep: '57035400',
  logradouro: 'Rua da casinha',
  complemento: '',
  bairro: 'Limoeiro',
  localidade: 'Campinas',
  uf: 'SP',
  ddd: '11',
);

void main() {
  setupFirebaseAnalyticsMocks();
  final getItTest = GetIt.instance;

  setUp(() async {
    //Variables initializer
    searchZipCubit = MockSearchZipCubit();
    favoriteCubit = MockFavoriteCubit();

    // Firebase Setup
    await Firebase.initializeApp();

    getItTest.registerLazySingleton<SharedServices>(
      () => SharedServices(),
    );
    getItTest.registerLazySingleton(() => FirebaseAnalytics.instance);

    registerFallbackValue(_addressModel);
    when(() => searchZipCubit.getBrStates()).thenReturn([]);
  });

  tearDown(
    () => getItTest.reset(),
  );

  testWidgets('Find inital widgets when state is inital', (tester) async {
    when(() => searchZipCubit.state).thenReturn(const InitialSearchState());

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);
  });

  testWidgets('Loading screen', (tester) async {
    when(() => searchZipCubit.state).thenReturn(LoadingSearchState());

    await _createWidget(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Find success screen widgets', (tester) async {
    when(() => searchZipCubit.state)
        .thenReturn(SuccessSearchState(_addressModel));

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);

    expect(find.byType(SuccessWidget), findsOneWidget);
  });

  group('Flushbar messages |', () {
    group('Success |', () {
      testWidgets('Find success flushbar after search valid ZIP',
          (tester) async {
        await tester.runAsync(() async {
          final state = StreamController<SearchState>();

          whenListen(
            searchZipCubit,
            state.stream,
            initialState: const InitialSearchState(),
          );

          await _createWidget(tester);

          state.add(
            const FavoriteAddressState(
              message: AppStrings.successZipFavoriteText,
            ),
          );
          await tester.pump();
          await tester.pump();
          await tester.pump();

          expect(
            find.text(AppStrings.successZipFavoriteText),
            findsOneWidget,
          );
        });
      });
    });

    group('Errors |', () {
      testWidgets('Find flushbar after search empty error', (tester) async {
        await tester.runAsync(() async {
          final state = StreamController<SearchState>();
          whenListen(
            searchZipCubit,
            state.stream,
            initialState: const InitialSearchState(),
          );

          await _createWidget(tester);

          state.add(
            const ErrorEmptyZipState(
              errorEmptyMessage: AppStrings.zipCodeEmptyErrorMessageText,
            ),
          );

          await tester.pump();
          await tester.pump();
          await tester.pump();

          expect(
            find.text(AppStrings.zipCodeEmptyErrorMessageText),
            findsOneWidget,
          );
        });
      });

      testWidgets('Find flushbar after search an invalid zip', (tester) async {
        await tester.runAsync(() async {
          final state = StreamController<SearchState>();

          whenListen(
            searchZipCubit,
            state.stream,
            initialState: const InitialSearchState(),
          );

          await _createWidget(tester);

          state.add(
            const ErrorSearchZipState(
              errorMessage: AppStrings.zipCodeInvalidErrorMessageText,
            ),
          );

          await tester.pump();
          await tester.pump();
          await tester.pump();

          expect(
            find.text(AppStrings.zipCodeInvalidErrorMessageText),
            findsOneWidget,
          );
        });
      });

      testWidgets('Find flushbar after add an already favorited address',
          (tester) async {
        await tester.runAsync(() async {
          final state = StreamController<SearchState>();

          whenListen(
            searchZipCubit,
            state.stream,
            initialState: const InitialSearchState(),
          );

          await _createWidget(tester);

          state.add(
            const ErrorAlreadyFavotiteZipState(
              errorMessage: AppStrings.alreadyFavoritedZipCodeText,
            ),
          );

          await tester.pump();
          await tester.pump();
          await tester.pump();

          expect(find.text(AppStrings.alreadyFavoritedZipCodeText),
              findsOneWidget);
        });
      });
    });
  });

  group('Navigation test', () {
    testWidgets(
        'Case user search address from SearchOptions.address and the result is success',
        (tester) async {
      await tester.runAsync(() async {
        whenListen(
            searchZipCubit,
            Stream.fromIterable(<SearchState>[
              LoadingSearchState(),
              SuccessAddressesSearchState([_addressModel])
            ]),
            initialState: const InitialSearchState());

        when(() => searchZipCubit.searchAddress(
            address: 'avenida',
            city: 'flora',
            state: 'SP')).thenAnswer((_) async => {});

        when(() => searchZipCubit.isAddresslreadyFavorited(
              address: _addressModel,
              addressList: [FavoriteModel(addressModel: _addressModel)],
            )).thenReturn(true);

        when(() => favoriteCubit.state).thenReturn(LoadFavoriteZipState(
            addresses: [FavoriteModel(addressModel: _addressModel)]));

        await _createWidget(tester);

        expect(find.text(AppStrings.searchPageMessage), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text(AppStrings.searchPageMessage), findsNothing);

        expect(find.text(AppStrings.resultsAppBarText), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });
    });
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>.value(value: searchZipCubit),
        BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
      ],
      child: const MaterialApp(
        home: SearchPage(),
      ),
    ),
  );
  await tester.pump();
}

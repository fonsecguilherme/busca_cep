import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/pages/search_page/search_page.dart';
import 'package:zip_search/pages/search_page/widgets/initial_widget.dart';
import 'package:zip_search/pages/search_page/widgets/success_widget.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

late SearchZipCubit searchZipCubit;

AddressModel _addressModel = const AddressModel(
  cep: '57035400',
  logradouro: 'Rua da casinha',
  complemento: ' ',
  bairro: 'Limoeiro',
  localidade: 'Campinas',
  uf: 'SP',
  ddd: '11',
);

void main() {
  setUp(() {
    searchZipCubit = MockSearchZipCubit();
  });

  testWidgets('Find inital widgets when state is inital', (tester) async {
    when(() => searchZipCubit.state).thenReturn(InitialSearchZipState());
    when(() => searchZipCubit.counterSearchedZips).thenReturn(0);

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);
  });

  testWidgets('Loading screen', (tester) async {
    when(() => searchZipCubit.state).thenReturn(LoadingSearchZipState());

    await _createWidget(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Find success screen widgets', (tester) async {
    when(() => searchZipCubit.state)
        .thenReturn(FetchedSearchZipState(_addressModel));
    when(() => searchZipCubit.counterSearchedZips).thenReturn(1);

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);

    expect(find.byType(SuccessWidget), findsOneWidget);
  });

  group('Flushbar messages |', () {
    group('Success |', () {
      testWidgets('Find success flushbar after search valid ZIP',
          (tester) async {
        await tester.runAsync(() async {
          final state = StreamController<SearchZipState>();

          whenListen(
            searchZipCubit,
            state.stream,
            initialState: InitialSearchZipState(),
          );

          await _createWidget(tester);

          state.add(
            FavoritedAddressZipState(
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
          final state = StreamController<SearchZipState>();
          whenListen(
            searchZipCubit,
            state.stream,
            initialState: InitialSearchZipState(),
          );

          await _createWidget(tester);

          state.add(
            ErrorEmptyZipState(
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
          final state = StreamController<SearchZipState>();

          whenListen(
            searchZipCubit,
            state.stream,
            initialState: InitialSearchZipState(),
          );

          await _createWidget(tester);

          state.add(
            ErrorSearchZipState(
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
          final state = StreamController<SearchZipState>();

          whenListen(
            searchZipCubit,
            state.stream,
            initialState: InitialSearchZipState(),
          );

          await _createWidget(tester);

          state.add(
            ErrorAlreadyAddedZipState(
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
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchZipCubit>.value(
      value: searchZipCubit,
      child: const MaterialApp(
        home: SearchPage(),
      ),
    ),
  );
  await tester.pump();
}

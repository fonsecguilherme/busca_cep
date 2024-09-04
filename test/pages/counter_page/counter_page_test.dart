import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/counter_page/counter_page.dart';
import 'package:zip_search/core/features/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/via_cep_repository.dart';

import '../../firebase_mock.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

class MockSharedServices extends Mock implements SharedServices {}

late SearchZipCubit searchZipCubit;
late SharedServices services;

void main() {
  setupFirebaseAnalyticsMocks();

  setUp(() async {
    await Firebase.initializeApp();

    searchZipCubit = MockSearchZipCubit();
    services = MockSharedServices();
  });

  tearDown(
    () {
      searchZipCubit.close();
    },
  );

  testWidgets('Find initial widgets', (tester) async {
    await _createWidget(tester);

    expect(find.byKey(CounterPage.counterPageKey), findsOneWidget);

    expect(find.text(AppStrings.greetingsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSearchedZipsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSavedZipsText), findsOneWidget);

    expect(find.text('0'), findsWidgets);
  });

  // TODO: write tests with updated counter value

  testWidgets('Find correct counter value when a correct zip is returned',
      (tester) async {
    when(() => services.getInt(any())).thenAnswer((_) async => 1);

    await _createWidget(tester);

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(CounterPage.counterPageKey), findsOneWidget);

    expect(find.text(AppStrings.greetingsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSearchedZipsText), findsOneWidget);

    expect(find.text(AppStrings.successfulSavedZipsText), findsOneWidget);

    expect(find.text('1'), findsWidgets);
  });



  // testWidgets('Find correct saved counter value when a favorite zip is saved',
  //     (tester) async {
  //   when(() => searchZipCubit.state).thenReturn(
  //       (FavoritedAddressZipState(message: 'CEP favoritado com sucesso!')));
  //   when(() => searchZipCubit.counterFavZips).thenReturn(1);

  //   await _createWidget(tester);

  //   expect(find.byKey(CounterPage.counterPageKey), findsOneWidget);

  //   expect(find.text(AppStrings.greetingsText), findsOneWidget);

  //   expect(find.text(AppStrings.successfulSearchedZipsText), findsOneWidget);

  //   expect(find.text(AppStrings.successfulSavedZipsText), findsOneWidget);

  //   await tester.pump();

  //   await tester.pumpAndSettle();

  //   expect(find.text('${searchZipCubit.counterFavZips}'), findsOneWidget);
  // });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchZipCubit(
              viaCepRepository: _repository,
              sharedServices: _sharedServices,
            ),
          ),
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
        ],
        child: const CounterPage(),
      ),
    ),
  );
}

final _repository = ViaCepRepository();
final _sharedServices = SharedServices();

AddressModel _addressModel = const AddressModel(
  cep: '57035400',
  logradouro: 'Rua da casinha',
  complemento: ' ',
  bairro: 'Limoeiro',
  localidade: 'Campinas',
  uf: 'SP',
  ddd: '11',
);

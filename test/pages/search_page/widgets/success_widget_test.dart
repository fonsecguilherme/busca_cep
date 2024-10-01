import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';
import 'package:zip_search/presentation/search_page/widgets/success_widget.dart';
import 'package:zip_search/core/model/address_model.dart';

import '../../../firebase_mock.dart';

class MockSearchZipCubit extends MockCubit<SearchState>
    implements SearchCubit {}

class MockTracker extends Mock implements FirebaseAnalytics {}

late SearchCubit searchZipCubit;
late FirebaseAnalytics analytics;

void main() {
  setupFirebaseAnalyticsMocks();

  setUp(() {
    searchZipCubit = MockSearchZipCubit();
    analytics = MockTracker();
  });

  testWidgets('Should show address after', (tester) async {
    when(() => searchZipCubit.state).thenReturn(SuccessSearchState(_address));

    when(() => searchZipCubit.counterSearchedZips).thenReturn(1);

    await _createWidget(tester);

    expect(find.byKey(SuccessWidget.addressFoundWidgetKey), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchCubit>.value(
      value: searchZipCubit,
      child: MaterialApp(
        home: Scaffold(
          body: SuccessWidget(
            address: _address,
            analytics: analytics,
          ),
        ),
      ),
    ),
  );
}

AddressModel _address = const AddressModel(
  cep: '57035400',
  logradouro: 'Rua da casinha',
  complemento: ' ',
  bairro: 'Limoeiro',
  localidade: 'Campinas',
  uf: 'SP',
  ddd: '11',
);

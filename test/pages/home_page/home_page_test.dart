import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/pages/home_page/home_page.dart';
import 'package:zip_search/pages/home_page/widgets/inital_widget.dart';
import 'package:zip_search/pages/home_page/widgets/success_widget.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

late SearchZipCubit searchZipCubit;

AddressModel _addressModel = AddressModel(
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
    when(() => searchZipCubit.counterValue).thenReturn(0);

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);
    expect(
        find.text(
            'Quantidade de ceps procuados com sucesso: ${searchZipCubit.counterValue}'),
        findsOneWidget);
  });

  testWidgets('Loading screen', (tester) async {
    when(() => searchZipCubit.state).thenReturn(LoadingSearchZipState());

    await _createWidget(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Find success screen widgets', (tester) async {
    when(() => searchZipCubit.state)
        .thenReturn(FetchedSearchZipState(_addressModel));
    when(() => searchZipCubit.counterValue).thenReturn(1);

    await _createWidget(tester);

    expect(find.byType(SuccessWidget), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchZipCubit>.value(
      value: searchZipCubit,
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );
  await tester.pump();
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/pages/search_page/widgets/success_widget.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

late SearchZipCubit searchZipCubit;
void main() {
  setUp(() {
    searchZipCubit = MockSearchZipCubit();
  });

  testWidgets('Should whow address after', (tester) async {
    when(() => searchZipCubit.counterSearchedZips).thenReturn(1);
    await _createWidget(tester);

    expect(find.byKey(SuccessWidget.addressFoundWidgetKey), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchZipCubit>.value(
      value: searchZipCubit,
      child: MaterialApp(
        home: Scaffold(
          body: SuccessWidget(address: _address),
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

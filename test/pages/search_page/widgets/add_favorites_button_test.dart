import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/pages/search_page/widgets/add_favorites_button.dart';

void main() {
  testWidgets('add favorites button ...', (tester) async {
    await _createWidget(tester);

    expect(find.text(AppStrings.addToFavoritesButton), findsOneWidget);
    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AddFavoritesButton(
        address: _address,
      ),
    ),
  );
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

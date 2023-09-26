import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/pages/search_page/widgets/add_favorites_button.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

late FavoritesCubit favoritesCubit;
late SearchZipCubit searchZipCubit;

void main() {
  setUp(() {
    favoritesCubit = MockFavoritesCubit();
    searchZipCubit = MockSearchZipCubit();
  });

  testWidgets('add favorites button ...', (tester) async {
    await _createWidget(tester);

    expect(find.text(AppStrings.addToFavoritesButton), findsOneWidget);
    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
  });

  // TODO: verify if functions were called
  testWidgets('Find if function were called after tap button', (tester) async {
    await _createWidget(tester);

    final buttonText = find.text(AppStrings.addToFavoritesButton);

    await tester.tap(buttonText);

    //verify(() => searchZipCubit.addToFavorites(_address)).called(1);
    // verify(() => favoritesCubit.loadFavoriteAdresses).called(1);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchZipCubit(),
          ),
          BlocProvider(
            create: (context) => FavoritesCubit(),
          ),
        ],
        child: AddFavoritesButton(
          address: _address,
        ),
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

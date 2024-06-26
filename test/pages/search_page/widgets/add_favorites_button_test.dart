import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/core/features/search_page/widgets/add_favorites_button.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/via_cep_repository.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

class FakeAddressModel extends Fake implements AddressModel {}

late FavoritesCubit favoritesCubit;
late SearchZipCubit searchZipCubit;

AddressModel _address = FakeAddressModel();

void main() {
  setUp(() {
    favoritesCubit = MockFavoritesCubit();
    searchZipCubit = MockSearchZipCubit();
    registerFallbackValue(_address);
  });

  tearDown(() {
    favoritesCubit.close();
    searchZipCubit.close();
  });

  testWidgets('add favorites button ...', (tester) async {
    await _createWidget(tester);

    expect(find.text(AppStrings.addToFavoritesButton), findsOneWidget);
    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
  });

  // TODO: verify if functions were called
  testWidgets('Find if functions were called after tap button', (tester) async {
    when(() => searchZipCubit.addToFavorites(any())).thenAnswer(
      (_) async => Future.value(),
    );

    when(() => favoritesCubit.loadFavoriteAdresses()).thenAnswer(
      (_) async => Future.value(),
    );

    await _createWidget(tester);

    final buttonText = find.text(AppStrings.addToFavoritesButton);

    await tester.tap(buttonText);
    await tester.pumpAndSettle();
    // await tester.pumpAndSettle();
    // await tester.pumpAndSettle();

    //! o erro está acontecendo aqui
    verify(() => searchZipCubit.addToFavorites(any()));
    verify(() => favoritesCubit.loadFavoriteAdresses());
    verifyNoMoreInteractions(searchZipCubit);
    verifyNoMoreInteractions(favoritesCubit);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          RepositoryProvider<IViaCepRepository>(
            create: (context) => ViaCepRepository(),
          ),
          RepositoryProvider(
            create: (context) => SharedServices(),
          ),
          BlocProvider(
            create: (context) => SearchZipCubit(
              viaCepRepository: context.read(),
              sharedServices: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesCubit(
              sharedServices: context.read(),
            ),
          ),
        ],
        child: AddFavoritesButton(
          address: _address,
        ),
      ),
    ),
  );
}

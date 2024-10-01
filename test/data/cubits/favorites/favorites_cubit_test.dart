import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';

class MockSharedServices extends Mock implements SharedServices {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FavoritesCubit favoritesCubit;
  late MockSharedServices sharedServices;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sharedServices = MockSharedServices();
    favoritesCubit = FavoritesCubit(sharedServices: sharedServices);
  });

  tearDown(
    () => favoritesCubit.close(),
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'If user has not favorited no adressess, shoudl emit InitialFavoriteState',
    build: () {
      favoritesCubit.addressList = [];

      when(() => sharedServices.getListString(any())).thenAnswer(
        (_) async => [],
      );

      return favoritesCubit;
    },
    act: (cubit) => cubit.loadFavoriteAdresses(),
    expect: () => <FavoritesState>[
      InitialFavoriteState(),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    ' If user favorites one address, should emit LoadFavoriteZipState // When favorites page has one address',
    build: () {
      when(() => sharedServices.getListString(any())).thenAnswer(
        (_) async => adressesList,
      );

      return favoritesCubit;
    },
    act: (cubit) => cubit.loadFavoriteAdresses(),
    expect: () => <FavoritesState>[
      LoadFavoriteZipState(adressesList),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'Show initial favorites page after delete one address',
    build: () {
      when(() => sharedServices.getListString(any())).thenAnswer(
        (_) async => adressesList,
      );

      when(
        () => sharedServices.saveListString(any(), []),
      ).thenAnswer((_) async => []);

      return favoritesCubit;
    },
    act: (cubit) => cubit.deleteAddress(address),
    expect: () => <FavoritesState>[
      DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText),
      InitialFavoriteState()
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'Show remaining addresses after delete one',
    build: () {
      when(() => sharedServices.getListString(any())).thenAnswer(
        (_) async => adressesList2,
      );

      when(() => sharedServices.saveListString(any(), removedAdressesList))
          .thenAnswer(
        (_) async => removedAdressesList,
      );

      return favoritesCubit;
    },
    act: (cubit) => cubit.deleteAddress(address),
    expect: () => <FavoritesState>[
      DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText),
      LoadFavoriteZipState(removedAdressesList),
    ],
  );
}

AddressModel address = const AddressModel(
  cep: '57035400',
  logradouro: 'logradouro',
  complemento: 'complemento',
  bairro: 'bairro',
  localidade: 'localidade',
  uf: 'uf',
  ddd: 'ddd',
);

List<AddressModel> adressesList = [
  const AddressModel(
    cep: '57035400',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
];

List<AddressModel> removedAdressesList = [
  const AddressModel(
    cep: '57035600',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
];

List<AddressModel> adressesList2 = [
  const AddressModel(
    cep: '57035400',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
  const AddressModel(
    cep: '57035600',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
];

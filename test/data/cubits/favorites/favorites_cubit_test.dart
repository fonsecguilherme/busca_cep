import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/model/address_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FavoritesCubit favoritesCubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    favoritesCubit = FavoritesCubit();
  });

  blocTest<FavoritesCubit, FavoritesState>(
    'If user has not favorited no adressess, shoudl emit InitialFavoriteState',
    build: () {
      favoritesCubit.addressList = [];
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
      favoritesCubit.addressList.add(address);
      return favoritesCubit;
    },
    act: (cubit) => cubit.loadFavoriteAdresses(),
    expect: () => <FavoritesState>[
      // InitialFavoriteState(),
      LoadFavoriteZipState(adressesList),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'Show initial favorites page after delete one address',
    build: () {
      favoritesCubit.addressList = adressesList;
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
      favoritesCubit.addressList = adressesList2;
      return favoritesCubit;
    },
    act: (cubit) => cubit.deleteAddress(address),
    expect: () => <FavoritesState>[
      DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText),
      LoadFavoriteZipState(adressesList2),
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

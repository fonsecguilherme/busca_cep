import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';

void main() {
  late FavoritesCubit favoritesCubit;

  setUp(() {
    favoritesCubit = FavoritesCubit();
  });

  blocTest<FavoritesCubit, FavoritesState>(
    'When favorites page has one address',
    build: () => favoritesCubit,
    act: (cubit) => cubit.loadFavoriteAdresses(),
    expect: () => <FavoritesState>[
      LoadFavoriteZipState(adresses),
    ],
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'Show initial favorites page after delete one address',
    build: () {
      favoritesCubit.addressList = adresses;
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
      favoritesCubit.addressList = adresses2;
      return favoritesCubit;
    },
    act: (cubit) => cubit.deleteAddress(address),
    expect: () => <FavoritesState>[
      DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText),
      LoadFavoriteZipState(adresses2),
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

List<AddressModel> adresses = [
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

List<AddressModel> adresses2 = [
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

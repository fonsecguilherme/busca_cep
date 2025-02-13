import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';

class MockSharedServices extends Mock implements SharedServices {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FavoriteCubit favoritesCubit;
  late MockSharedServices sharedServices;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sharedServices = MockSharedServices();
    favoritesCubit = FavoriteCubit(sharedServices: sharedServices);
  });

  tearDown(
    () => favoritesCubit.close(),
  );

  group('Load Favorite Addresses function tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'If user has not favorited no adressess, shoudl emit InitialFavoriteState',
      build: () {
        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => [],
        );

        return favoritesCubit;
      },
      act: (cubit) => cubit.loadFavoriteAdresses(),
      expect: () => <FavoriteState>[
        const InitialFavoriteState(),
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      ' If user favorites one address, should emit LoadFavoriteZipState // When favorites page has one address',
      build: () {
        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => _adressesList,
        );

        return favoritesCubit;
      },
      act: (cubit) => cubit.loadFavoriteAdresses(),
      expect: () => <FavoriteState>[
        LoadFavoriteZipState(addresses: _adressesList),
      ],
    );
  });

  group('Delete Address function tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'Show initial favorites page after delete one address',
      build: () {
        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => _adressesList,
        );

        when(
          () => sharedServices.saveListString(any(), []),
        ).thenAnswer((_) async => []);

        return favoritesCubit;
      },
      act: (cubit) => cubit.deleteAddress(_address),
      expect: () => <FavoriteState>[
        const DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText),
        const InitialFavoriteState()
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'Show remaining addresses after delete one',
      build: () {
        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => adressesList2,
        );

        when(() => sharedServices.saveListString(any(), _removedAdressesList))
            .thenAnswer(
          (_) async => _removedAdressesList,
        );

        return favoritesCubit;
      },
      act: (cubit) => cubit.deleteAddress(_address),
      expect: () => <FavoriteState>[
        const DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText),
        LoadFavoriteZipState(addresses: _removedAdressesList),
      ],
    );
  });

  group('Tag tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'Should create a tag case it has not been added to tags list',
      build: () {
        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => [_address],
        );

        when(
          () => sharedServices
              .saveListString(SharedPreferencesKeys.savedAdresses, [
            _address.copyWith(tags: ['busca cep'])
          ]),
        ).thenAnswer((_) async => [
              _address.copyWith(tags: ['busca cep'])
            ]);

        return favoritesCubit;
      },
      act: (cubit) =>
          cubit.createTag(favoriteAddress: _address, tag: 'busca cep'),
      expect: () => <FavoriteState>[
        const AddedTagZipState(AppStrings.addTagSuccessText, ['busca cep']),
        LoadFavoriteZipState(addresses: [
          _address.copyWith(tags: ['busca cep'])
        ])
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'Should remove a tag case it has already been added to tags list',
      build: () {
        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => [
            _address.copyWith(tags: ['busca cep'])
          ],
        );

        when(
          () => sharedServices.saveListString(
              SharedPreferencesKeys.savedAdresses,
              [_address.copyWith(tags: [])]),
        ).thenAnswer(
          (_) async => [_address.copyWith(tags: [])],
        );

        return favoritesCubit;
      },
      act: (cubit) => cubit.createTag(
          favoriteAddress: _address.copyWith(tags: ['busca cep']),
          tag: 'busca cep'),
      expect: () => <FavoriteState>[
        const RemovedTagZipState(AppStrings.addTagSuccessText, []),
        LoadFavoriteZipState(
          addresses: [_address.copyWith(tags: [])],
        )
      ],
    );
  });

  group('Toggle AppBar function tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'Should emit a new appbar type state',
      build: () => favoritesCubit,
      act: (cubit) =>
          favoritesCubit.toggleAppBar(newAppBarType: AppBarType.search),
      expect: () => const <FavoriteState>[
        LoadFavoriteZipState(appBarType: AppBarType.search)
      ],
    );
  });

  group('Filter Address function tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'Case query is empty should change Appbar to normal',
      build: () => favoritesCubit,
      act: (cubit) => cubit.filterAddresses(query: ''),
      expect: () => const <FavoriteState>[
        LoadFavoriteZipState(appBarType: AppBarType.normal)
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'Should return an address case query correspond to smething in favorited address list',
      seed: () => LoadFavoriteZipState(
        appBarType: AppBarType.search,
        addresses: adressesList2,
        filteredAddresses: const [],
      ),
      build: () => favoritesCubit,
      act: (cubit) => cubit.filterAddresses(query: 'logradouro'),
      expect: () => <FavoriteState>[
        LoadFavoriteZipState(
          appBarType: AppBarType.search,
          addresses: adressesList2,
          filteredAddresses: adressesList2,
        )
      ],
    );
  });
}

final _address = FavoriteModel(
  addressModel: const AddressModel(
    cep: '57035400',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
);

final _adressesList = [
  FavoriteModel(
    addressModel: const AddressModel(
      cep: '57035400',
      logradouro: 'logradouro',
      complemento: 'complemento',
      bairro: 'bairro',
      localidade: 'localidade',
      uf: 'uf',
      ddd: 'ddd',
    ),
  ),
];

final _removedAdressesList = [
  FavoriteModel(
    addressModel: const AddressModel(
      cep: '57035600',
      logradouro: 'logradouro',
      complemento: 'complemento',
      bairro: 'bairro',
      localidade: 'localidade',
      uf: 'uf',
      ddd: 'ddd',
    ),
  ),
];

final adressesList2 = [
  FavoriteModel(
    addressModel: const AddressModel(
      cep: '57035400',
      logradouro: 'logradouro',
      complemento: 'complemento',
      bairro: 'bairro',
      localidade: 'localidade',
      uf: 'uf',
      ddd: 'ddd',
    ),
  ),
  FavoriteModel(
    addressModel: const AddressModel(
      cep: '57035600',
      logradouro: 'logradouro',
      complemento: 'complemento',
      bairro: 'bairro',
      localidade: 'localidade',
      uf: 'uf',
      ddd: 'ddd',
    ),
  ),
];

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/model/address_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

late SearchZipCubit searchZipCubit;
late SharedPreferences sharedPreferences;
void main() {
  setUp(() {
    searchZipCubit = SearchZipCubit();
    sharedPreferences = MockSharedPreferences();

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Search ZIP tests |', () {
    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit FetchedSearchZipState when user search a valid ZIP',
      build: () => searchZipCubit,
      act: (cubit) => cubit.searchZip(zipCode: '06053040'),
      expect: () => <SearchZipState>[
        LoadingSearchZipState(),
        FetchedSearchZipState(_address)
      ],
    );
    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit ErrorSearchZipState when user search empty ZIP',
      build: () => searchZipCubit,
      act: (cubit) => cubit.searchZip(zipCode: ''),
      expect: () => <SearchZipState>[
        LoadingSearchZipState(),
        ErrorEmptyZipState(
          errorEmptyMessage: AppStrings.zipCodeEmptyErrorMessageText,
        )
      ],
    );

    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit ErrorSearchZipState when user search an invalid ZIP',
      build: () => searchZipCubit,
      act: (cubit) => cubit.searchZip(zipCode: 'zipCode'),
      expect: () => <SearchZipState>[
        LoadingSearchZipState(),
        ErrorSearchZipState(
          errorMessage: AppStrings.zipCodeInvalidErrorMessageText,
        )
      ],
    );
  });

  group('Add favorites tests |', () {
    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit ErrorAlreadyAddedZipState when user try to add same address',
      build: () {
        searchZipCubit.addressList = [_address];
        return searchZipCubit;
      },
      act: (cubit) => cubit.addToFavorites(_address),
      expect: () => <SearchZipState>[
        ErrorAlreadyAddedZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText,
        )
      ],
    );

    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit FavoritedAddressZipState when user try to add a new address',
      build: () {
        searchZipCubit.addressList = [];
        return searchZipCubit;
      },
      act: (cubit) => cubit.addToFavorites(_address),
      expect: () => <SearchZipState>[
        FavoritedAddressZipState(message: AppStrings.successZipFavoriteText),
      ],
    );
  });
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

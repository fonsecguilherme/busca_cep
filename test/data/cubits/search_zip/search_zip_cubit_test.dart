import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/via_cep_repository.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSharedServices extends Mock implements SharedServices {}

class MockIViaCepRepository extends Mock implements IViaCepRepository {}

void main() {
  late SearchZipCubit searchZipCubit;
  late MockSharedServices sharedServices;
  late MockIViaCepRepository repository;

  setUp(() {
    repository = MockIViaCepRepository();
    sharedServices = MockSharedServices();
    searchZipCubit = SearchZipCubit(
        sharedServices: sharedServices, viaCepRepository: repository);

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Search ZIP tests |', () {
    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit FetchedSearchZipState when user search a valid ZIP',
      build: () {
        when(() => sharedServices.getInt(any())).thenAnswer(
          (_) async => Future.value(),
        );
        when(() => repository.fetchAddress(any())).thenAnswer(
          (_) async => _address,
        );
        when(() => sharedServices.saveInt(any(), 1)).thenAnswer(
          (_) => Future.value(),
        );

        return searchZipCubit;
      },
      act: (cubit) => cubit.searchZip(zipCode: '06053040'),
      expect: () => <SearchZipState>[
        LoadingSearchZipState(),
        FetchedSearchZipState(_address)
      ],
    );
    blocTest<SearchZipCubit, SearchZipState>(
      'Should emit ErrorSearchZipState when user search empty ZIP',
      build: () {
        when(() => sharedServices.getInt(any())).thenAnswer(
          (_) async => 0,
        );
        when(() => repository.fetchAddress(any())).thenThrow(
          Exception(),
        );
        when(() => sharedServices.saveInt(any(), 0)).thenAnswer(
          (_) => Future.value(),
        );
        return searchZipCubit;
      },
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
      build: () {
        when(() => sharedServices.getInt(any())).thenAnswer(
          (_) async => Future.value(),
        );
        when(() => repository.fetchAddress(any())).thenThrow(
          Exception(),
        );
        when(() => sharedServices.saveInt(any(), 1)).thenAnswer(
          (_) => Future.value(),
        );

        return searchZipCubit;
      },
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
        when(() => sharedServices.getInt(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => sharedServices.getListString(any())).thenAnswer(
          (invocation) async => _addressList,
        );

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
        when(() => sharedServices.getInt(any())).thenAnswer(
          (_) async => 0,
        );

        when(() => sharedServices.getListString(any())).thenAnswer(
          (_) async => [],
        );

        when(() => sharedServices.saveInt(any(), 1)).thenAnswer(
          (_) async => 1,
        );

        when(() => sharedServices.saveListString(any(), [_address])).thenAnswer(
          (_) async => [],
        );

        return searchZipCubit;
      },
      act: (cubit) => cubit.addToFavorites(_address),
      expect: () => <SearchZipState>[
        FavoritedAddressZipState(
          message: AppStrings.successZipFavoriteText,
        ),
      ],
    );
  });
}

AddressModel _address = const AddressModel(
  cep: '06053040',
  logradouro: 'logradouro',
  complemento: 'complemento',
  bairro: 'bairro',
  localidade: 'localidade',
  uf: 'uf',
  ddd: 'ddd',
);
final _addressList = [
  const AddressModel(
    cep: '06053040',
    logradouro: 'logradouro',
    complemento: 'complemento',
    bairro: 'bairro',
    localidade: 'localidade',
    uf: 'uf',
    ddd: 'ddd',
  ),
];

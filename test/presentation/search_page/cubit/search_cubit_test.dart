import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/exceptions/error.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/repositories/via_cep_repository.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSharedServices extends Mock implements SharedServices {}

class MockIViaCepRepository extends Mock implements IViaCepRepository {}

void main() {
  late SearchCubit searchZipCubit;
  late MockSharedServices sharedServices;
  late MockIViaCepRepository repository;

  setUp(() {
    repository = MockIViaCepRepository();
    sharedServices = MockSharedServices();
    searchZipCubit = SearchCubit(
        sharedServices: sharedServices, viaCepRepository: repository);

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Search ZIP tests |', () {
    blocTest<SearchCubit, SearchState>(
      'Should emit FetchedSearchZipState when user search a valid ZIP',
      build: () {
        when(() => sharedServices.getInt(any())).thenAnswer(
          (_) async => Future.value(),
        );
        when(
          () => repository.fetchAddress(any()),
        ).thenAnswer(
          (_) async => (data: _address, error: Empty()),
        );
        when(() => sharedServices.saveInt(any(), 1)).thenAnswer(
          (_) => Future.value(),
        );

        return searchZipCubit;
      },
      act: (cubit) => cubit.searchZip(zipCode: '06053040'),
      expect: () =>
          <SearchState>[LoadingSearchState(), SuccessSearchState(_address)],
    );

    group('Error tests | ', () {
      blocTest<SearchCubit, SearchState>(
        'Should emit ErrorSearchZipState when user search empty ZIP',
        build: () {
          when(() => sharedServices.getInt(any())).thenAnswer(
            (_) async => 0,
          );
          when(
            () => repository.fetchAddress(any()),
          ).thenAnswer((_) async => (
                data: null,
                error: EmptyZipFailure(message: 'User did not type any CEP')
              ));

          when(() => sharedServices.saveInt(any(), 0)).thenAnswer(
            (_) => Future.value(),
          );
          return searchZipCubit;
        },
        act: (cubit) => cubit.searchZip(zipCode: ''),
        expect: () => <SearchState>[
          LoadingSearchState(),
          ErrorEmptyZipState(
              errorEmptyMessage: AppStrings.zipCodeEmptyErrorMessageText)
        ],
      );

      blocTest<SearchCubit, SearchState>(
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
        expect: () => <SearchState>[
          LoadingSearchState(),
          ErrorSearchZipState(
            errorMessage: AppStrings.zipCodeInvalidErrorMessageText,
          )
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'Should emit Failure when Api return an unexpected Error',
        build: () {
          when(() => sharedServices.getInt(any())).thenAnswer(
            (_) async => Future.value(),
          );
          when(
            () => repository.fetchAddress(any()),
          ).thenAnswer((_) async =>
              (data: null, error: Failure(message: 'Unexpected Error')));

          when(() => sharedServices.saveInt(any(), 1)).thenAnswer(
            (_) => Future.value(),
          );

          return searchZipCubit;
        },
        act: (cubit) => cubit.searchZip(zipCode: 'zipCode'),
        expect: () => <SearchState>[
          LoadingSearchState(),
          ErrorSearchZipState(
            errorMessage: 'Unexpected Error',
          )
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'Should emit Failure when Api return an exception',
        build: () {
          when(() => sharedServices.getInt(any())).thenAnswer(
            (_) async => Future.value(),
          );
          when(
            () => repository.fetchAddress(any()),
          ).thenThrow((_) async => (
                data: null,
                error: Failure(
                  message: 'Exception',
                ),
              ));

          when(() => sharedServices.saveInt(any(), 1)).thenAnswer(
            (_) => Future.value(),
          );

          return searchZipCubit;
        },
        act: (cubit) => cubit.searchZip(zipCode: 'zipCode'),
        expect: () => <SearchState>[
          LoadingSearchState(),
          ErrorSearchZipState(
            errorMessage: 'Exception',
          )
        ],
      );
    });
  });

  group('Add favorites tests |', () {
    blocTest<SearchCubit, SearchState>(
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
      expect: () => <SearchState>[
        ErrorAlreadyFavotiteZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText,
        )
      ],
    );

    blocTest<SearchCubit, SearchState>(
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
      expect: () => <SearchState>[
        FavoriteAddressState(
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

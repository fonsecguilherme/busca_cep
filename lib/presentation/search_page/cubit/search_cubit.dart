import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/repositories/via_cep_repository.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';

import '../../../core/commons/logger_helper.dart';
import '../../../core/exceptions/custom_exceptions.dart';
import '../../../core/model/favorite_model.dart';


class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.viaCepRepository,
    required this.sharedServices,
  }) : super(const InitialSearchState());

  final SharedServices sharedServices;
  final IViaCepRepository viaCepRepository;
  List<FavoriteModel> addressList = [];
  List<FavoriteModel> favoriteList = [];
  int counterSearchedZips = 0;
  int counterFavZips = 0;

  Future<void> searchZip({required String zipCode}) async {
    counterSearchedZips = await sharedServices
            .getInt(SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearchedZips;

    emit(LoadingSearchState());

    try {
      final address = await viaCepRepository.fetchAddress(zipCode);

      LoggerHelper.debug('${AppStrings.seachedZipLog} $zipCode');

      if (address != null) {
        counterSearchedZips += 1;
        await sharedServices.saveInt(
            SharedPreferencesKeys.counterSearchedZipsKeys, counterSearchedZips);
        LoggerHelper.debug(address.toString());
        emit(SuccessSearchState(address));
      }
    } on EmptyZipException catch (e) {
      LoggerHelper.error(e.message);

      emit(const ErrorEmptyZipState(
          errorEmptyMessage: AppStrings.zipCodeEmptyErrorMessageText));
    } on InvalidZipException catch (e) {
      LoggerHelper.error(e.message);

      emit(const ErrorSearchZipState(
          errorMessage: AppStrings.zipCodeInvalidErrorMessageText));
    } on Exception catch (e, stacktrace) {
      LoggerHelper.error(e.toString());
      LoggerHelper.error(stacktrace.toString());

      emit(ErrorSearchZipState(errorMessage: e.toString()));
    }
  }

  Future<void> searchAddress({
    required String address,
    required String city,
    required String state,
  }) async {
    counterSearchedZips = await sharedServices
            .getInt(SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearchedZips;

    state = state.split(' - ').last;

    emit(LoadingSearchState());

    if (city.length < 3 || address.length < 3) {
      emit(const ErrorSearchZipState(
          errorMessage: 'Ops, você precisa digitar ao menos 3 '
              'letras nos campos de endereço ou cidade'));
      return;
    }

    try {
      final addressList = await viaCepRepository.fetchAddressList(
        address: address,
        state: state,
        city: city,
      );

      if (addressList != null) {
        addressList.sort(
          (a, b) => a.cep.compareTo(b.cep),
        );
      }

      LoggerHelper.debug(
          'Foram retornados ${addressList?.length ?? 0} endereços');

      if (addressList != null) {
        counterSearchedZips += 1;
        await sharedServices.saveInt(
            SharedPreferencesKeys.counterSearchedZipsKeys, counterSearchedZips);
        emit(SuccessAddressesSearchState(addressList));
      }
    } on InvalidAddressException catch (e) {
      LoggerHelper.error(e.toString());

      emit(ErrorSearchZipState(errorMessage: e.message));
    } on Exception catch (e, stacktrace) {
      LoggerHelper.error(e.toString());
      LoggerHelper.error(stacktrace.toString());
      
      final (data: result, error: error) =
          await viaCepRepository.fetchAddress(zipCode);

      if (error is EmptyZipFailure) {
        log(error.message);
        emit(ErrorEmptyZipState(
            errorEmptyMessage: AppStrings.zipCodeEmptyErrorMessageText));
        return;
      }

      if (error is InvalidZipFailure) {
        log(error.message);
        emit(ErrorSearchZipState(
            errorMessage: AppStrings.zipCodeInvalidErrorMessageText));
        return;
      }
      counterSearchedZips += 1;
      await sharedServices.saveInt(
          SharedPreferencesKeys.counterSearchedZipsKeys, counterSearchedZips);

      return emit(SuccessSearchState(result!));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      log(error.toString());


      emit(ErrorSearchZipState(errorMessage: error.toString()));
    }
  }

  Future<void> addToFavorites(
    AddressModel address,
  ) async {
    counterFavZips =
        await sharedServices.getInt(SharedPreferencesKeys.savedZipKey) ??
            counterFavZips;

    favoriteList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (favoriteList.any((element) => element.addressModel == address)) {
      emit(const ErrorAlreadyFavotiteZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText));
    } else {
      counterFavZips++;

      await sharedServices.saveInt(
          SharedPreferencesKeys.savedZipKey, counterFavZips);

      favoriteList.add(FavoriteModel(addressModel: address));

      await sharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, favoriteList);

      emit(const FavoriteAddressState(
        message: AppStrings.successZipFavoriteText,
      ));
    }
  }

  Future<void> toggleOption() async {
    final currentOption = state.selectedOption;

    final newOption = currentOption == SearchOptions.address
        ? SearchOptions.zip
        : SearchOptions.address;

    LoggerHelper.debug('Opção escolhida: ${currentOption.name}');

    emit(InitialSearchState(searchOption: newOption));
  }

  List<String> getBrStates() {
    const statesList = [
      "Acre - AC",
      "Alagoas - AL",
      "Amapá - AP",
      "Amazonas - AM",
      "Bahia - BA",
      "Ceará - CE",
      "Distrito Federal - DF",
      "Espírito Santo - ES",
      "Goiás - GO",
      "Maranhão - MA",
      "Mato Grosso - MT",
      "Mato Grosso do Sul - MS",
      "Minas Gerais - MG",
      "Pará - PA",
      "Paraíba - PB",
      "Paraná - PR",
      "Pernambuco - PE",
      "Piauí - PI",
      "Rio de Janeiro - RJ",
      "Rio Grande do Norte - RN",
      "Rio Grande do Sul - RS",
      "Rondônia - RO",
      "Roraima - RR",
      "Santa Catarina - SC",
      "São Paulo - SP",
      "Sergipe - SE",
      "Tocantins - TO"
    ];

    return statesList;
  }

  bool isAddresslreadyFavorited({
    required AddressModel address,
    required List<FavoriteModel> addressList,
  }) {
    return addressList.any(
      (stateAddress) => stateAddress.addressModel.cep == address.cep,
    );
  }
}

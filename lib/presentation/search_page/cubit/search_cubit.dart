import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/repositories/via_cep_repository.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';

import '../../../core/exceptions/error.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.viaCepRepository,
    required this.sharedServices,
  }) : super(InitialSearchState());

  final SharedServices sharedServices;
  final IViaCepRepository viaCepRepository;
  List<AddressModel> addressList = [];
  int counterSearchedZips = 0;
  int counterFavZips = 0;

  Future<void> searchZip({required String zipCode}) async {
    counterSearchedZips = await sharedServices
            .getInt(SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearchedZips;

    emit(LoadingSearchState());

    try {
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

    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (addressList.contains(address)) {
      emit(ErrorAlreadyFavotiteZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText));
    } else {
      counterFavZips++;

      await sharedServices.saveInt(
          SharedPreferencesKeys.savedZipKey, counterFavZips);

      addressList.add(address);

      await sharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, addressList);

      emit(FavoriteAddressState(
        message: AppStrings.successZipFavoriteText,
      ));
    }
  }
}

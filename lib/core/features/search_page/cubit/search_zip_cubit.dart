import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/via_cep_repository.dart';

class SearchZipCubit extends Cubit<SearchZipState> {
  SearchZipCubit({
    required this.viaCepRepository,
    required this.sharedServices,
  })  : 
        super(InitialSearchZipState());

  final SharedServices sharedServices;
  final IViaCepRepository viaCepRepository;
  List<AddressModel> addressList = [];
  int counterSearchedZips = 0;
  int counterFavZips = 0;

  Future<void> searchZip({required String zipCode}) async {
    counterSearchedZips = await sharedServices
            .getInt(SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearchedZips;

    emit(LoadingSearchZipState());

    try {
      final address = await viaCepRepository.fetchAddress(zipCode);

      if (address != null) {
        counterSearchedZips += 1;
        await sharedServices.saveInt(
            SharedPreferencesKeys.counterSearchedZipsKeys, counterSearchedZips);
        emit(FetchedSearchZipState(address));
      }
    } on Exception {
      if (zipCode.isEmpty) {
        emit(ErrorEmptyZipState(
            errorEmptyMessage: AppStrings.zipCodeEmptyErrorMessageText));
      } else {
        emit(ErrorSearchZipState(
            errorMessage: AppStrings.zipCodeInvalidErrorMessageText));
      }
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
      emit(ErrorAlreadyAddedZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText));
    } else {
      counterFavZips++;

      await sharedServices.saveInt(
          SharedPreferencesKeys.savedZipKey, counterFavZips);

      addressList.add(address);

      await sharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, addressList);

      emit(FavoritedAddressZipState(
        message: AppStrings.successZipFavoriteText,
      ));
    }
  }
}

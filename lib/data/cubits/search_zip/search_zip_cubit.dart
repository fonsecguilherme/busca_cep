import 'package:bloc/bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/commons/shared_preferences_keys.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/data/via_cep_repository.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/services/shared_services.dart';

class SearchZipCubit extends Cubit<SearchZipState> {
  SearchZipCubit({
    ViaCepRepository? viaCepRepository,
  })  : _viaCepRepository = viaCepRepository ?? ViaCepRepository(),
        super(InitialSearchZipState());

  final ViaCepRepository _viaCepRepository;
  List<AddressModel> addressList = [];
  int counterSearchedZips = 0;
  int counterFavZips = 0;

  Future<void> searchZip({required String zipCode}) async {
    counterSearchedZips = await SharedServices.getInt(
            SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearchedZips;

    emit(LoadingSearchZipState());

    try {
      final address = await _viaCepRepository.fetchAddress(zipCode);

      if (address != null) {
        counterSearchedZips += 1;
        await SharedServices.saveInt(
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

  Future<void> addToFavorites(AddressModel address) async {
    counterFavZips =
        await SharedServices.getInt(SharedPreferencesKeys.savedZipKey) ??
            counterFavZips;

    addressList =
        await SharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (addressList.contains(address)) {
      emit(ErrorAlreadyAddedZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText));
    } else {
      counterFavZips++;

      await SharedServices.saveInt(
          SharedPreferencesKeys.savedZipKey, counterFavZips);

      addressList.add(address);

      await SharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, addressList);
      emit(
          FavoritedAddressZipState(message: AppStrings.successZipFavoriteText));
    }
  }
}

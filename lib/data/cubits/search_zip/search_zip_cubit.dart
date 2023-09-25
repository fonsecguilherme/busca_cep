import 'package:bloc/bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/data/via_cep_repository.dart';
import 'package:zip_search/model/address_model.dart';

class SearchZipCubit extends Cubit<SearchZipState> {
  SearchZipCubit({
    ViaCepRepository? viaCepRepository,
  })  : _viaCepRepository = viaCepRepository ?? ViaCepRepository(),
        super(InitialSearchZipState());

  final ViaCepRepository _viaCepRepository;
  List<AddressModel> addressList = [];
  //List<AddressModel> get addressList => _addressList;
  //set addressList(List<AddressModel> addressList) => _addressList = addressList;
  int counterSearchedZips = 0;
  int counterFavZips = 0;

  Future<void> searchZip({required String zipCode}) async {
    emit(LoadingSearchZipState());

    try {
      final address = await _viaCepRepository.fetchAddress(zipCode);

      if (address != null) {
        counterSearchedZips += 1;
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

  void addToFavorites(AddressModel address) {
    if (addressList.contains(address)) {
      emit(ErrorAlreadyAddedZipState(
          errorMessage: AppStrings.alreadyFavoritedZipCodeText));
    } else {
      addressList.add(address);
      counterFavZips++;
      emit(
          FavoritedAddressZipState(message: AppStrings.successZipFavoriteText));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/data/via_cep_repository.dart';
import 'package:zip_search/model/address_model.dart';

class SearchZipCubit extends Cubit<SearchZipState> {
  SearchZipCubit({
    ViaCepRepository? viaCepRepository,
  })  : _viaCepRepository = viaCepRepository ?? ViaCepRepository(),
        super(InitialSearchZipState());

  final ViaCepRepository _viaCepRepository;
  final List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;
  int counterValue = 0;
  int counterFavZips = 0;

  Future<void> searchZip({required String zipCode}) async {
    emit(LoadingSearchZipState());

    try {
      final address = await _viaCepRepository.fetchAddress(zipCode);

      if (address != null) {
        counterValue += 1;
        emit(FetchedSearchZipState(address));
      }
    } on Exception {
      if (zipCode.isEmpty) {
        emit(ErrorSearchZipState(
            errorMessage: 'Parece não foi digitado nenhum CEP!'));
      } else {
        emit(ErrorSearchZipState(errorMessage: 'CEP digitado não é válido.'));
      }
    }
  }

  void addToFavorites(AddressModel address) {
    if (_addressList.contains(address)) {
      emit(ErrorAlreadyAddedZipState(
          errorMessage: 'Ops! Esse cep já foi favoritado'));
    } else {
      _addressList.add(address);
      counterFavZips++;
      emit(FavoritedAddressZipState(message: 'CEP favoritado com sucesso!'));
    }
  }
}

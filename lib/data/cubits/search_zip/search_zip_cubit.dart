import 'package:bloc/bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/data/via_cep_repository.dart';

class SearchZipCubit extends Cubit<SearchZipState> {
  SearchZipCubit({
    ViaCepRepository? viaCepRepository,
  })  : _viaCepRepository = viaCepRepository ?? ViaCepRepository(),
        super(InitialSearchZipState());

  final ViaCepRepository _viaCepRepository;
  int counterValue = 0;

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
}

import 'package:bloc/bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/data/via_cep_repository.dart';

class SearchZipCubit extends Cubit<SearchZipState> {
  SearchZipCubit(this.repository) : super(InitialSearchZipState());

  final ViaCepRepository repository;

  Future<void> searchZip({required String zipCode}) async {
    emit(LoadingSearchZipState());

    if (zipCode.isNotEmpty) {
      final address = await repository.fetchAddress(zipCode);

      emit(FetchedSearchZipState(address));
    } else if (zipCode.isEmpty) {
      emit(ErrorSearchZipState(
          errorMessage: 'Parece não foi digitado nenhum CEP!'));
      emit(InitialSearchZipState());
    } else {
      emit(ErrorSearchZipState(errorMessage: 'Parece que algo deu errado!'));
    }
  }
}

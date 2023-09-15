import 'package:bloc/bloc.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(InitialFavoriteState());

  void loadFavoriteAddresses(List<AddressModel> addresses) {
    emit(LoadFavoriteZipState(addresses));
  }

  //! Implement remove address from favorites list
  void deleteAddress(List<AddressModel> adresses, AddressModel address) {
    adresses.removeWhere((element) => element.cep == address.cep);

    emit(DeletedFavoriteZipState('CEP deletado com sucesso!'));
    if (adresses.isEmpty) {
      emit(InitialFavoriteState());
    } else {
      emit(LoadFavoriteZipState(adresses));
    }
  }
}

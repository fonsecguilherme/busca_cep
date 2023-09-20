import 'package:bloc/bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(InitialFavoriteState());

  List<AddressModel> addressList = [];

  void loadFavoriteAdresses() {
    emit(LoadFavoriteZipState(addressList));
  }

  void deleteAddress(AddressModel address) {
    addressList.removeWhere((element) => element.cep == address.cep);

    emit(DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText));
    if (addressList.isEmpty) {
      emit(InitialFavoriteState());
    } else {
      emit(LoadFavoriteZipState(addressList));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/commons/shared_preferences_keys.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/services/shared_services.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(InitialFavoriteState());

  List<AddressModel> addressList = [];

  Future<void> loadFavoriteAdresses() async {
    addressList =
        await SharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (addressList.isEmpty) {
      emit(InitialFavoriteState());
    } else {
      emit(LoadFavoriteZipState(addressList));
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    addressList =
        await SharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    addressList.removeWhere((element) => element.cep == address.cep);

    await SharedServices.saveListString(
        SharedPreferencesKeys.savedAdresses, addressList);

    emit(DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText));
    if (addressList.isEmpty) {
      emit(InitialFavoriteState());
    } else {
      emit(LoadFavoriteZipState(addressList));
    }
  }
}

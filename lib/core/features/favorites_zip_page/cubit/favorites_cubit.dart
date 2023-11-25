import 'package:bloc/bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/data/shared_services.dart';

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

import 'package:bloc/bloc.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';

import '../../../core/commons/app_strings.dart';

class FavoriteCubit extends Cubit<FavoritesState> {
  FavoriteCubit({
    required this.sharedServices,
  }) : super(InitialFavoriteState());

  final SharedServices sharedServices;
  List<AddressModel> addressList = [];

  Future<void> loadFavoriteAdresses() async {
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (addressList.isEmpty) {
      emit(InitialFavoriteState());
      return;
    }

    emit(LoadFavoriteZipState(addressList));
  }

  Future<void> deleteAddress(AddressModel address) async {
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    addressList.removeWhere((element) => element.cep == address.cep);

    await sharedServices.saveListString(
        SharedPreferencesKeys.savedAdresses, addressList);

    emit(DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText));
    if (addressList.isEmpty) {
      emit(InitialFavoriteState());
      return;
    }
    emit(LoadFavoriteZipState(addressList));
  }

  Future<void> createTag({
    required FavoriteModel favoriteAddress,
    required String tag,
  }) async {
    if (favoriteAddress.tags.isEmpty || favoriteAddress.tags.length < 5) {
      favoriteAddress.tags.add(tag);
      return;
    }

    if (favoriteAddress.tags.contains(tag)) {
      favoriteAddress.tags.remove(tag);
      return;
    }
    emit(state);
  }
}

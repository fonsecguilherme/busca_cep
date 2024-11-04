import 'package:bloc/bloc.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';

import '../../../core/commons/app_strings.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({
    required this.sharedServices,
  }) : super(InitialFavoriteState());

  final SharedServices sharedServices;
  List<FavoriteModel> addressList = [];

  Future<void> loadFavoriteAdresses() async {
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (addressList.isEmpty) {
      emit(InitialFavoriteState());
      return;
    }

    emit(LoadFavoriteZipState(addressList));
  }

  Future<void> deleteAddress(FavoriteModel address) async {
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    addressList.removeWhere(
        (element) => element.addressModel.cep == address.addressModel.cep);

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
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    final address = addressList.firstWhere((element) =>
        element.addressModel.cep == favoriteAddress.addressModel.cep);

    if (!favoriteAddress.tags.contains(tag) &&
        favoriteAddress.tags.length < 5) {
      address.tags.add(tag);
      address.copyWith(tags: favoriteAddress.tags);

      await sharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, addressList);

      emit(AddedTagZipState(AppStrings.addTagSuccessText, address.tags));
      emit(LoadFavoriteZipState(addressList));
      return;
    }

    if (favoriteAddress.tags.contains(tag)) {
      address.tags.remove(tag);
      address.copyWith(tags: favoriteAddress.tags);

      await sharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, addressList);
      emit(RemovedTagZipState(AppStrings.removeTagSuccessText, address.tags));
      emit(LoadFavoriteZipState(addressList));
      return;
    }
  }
}

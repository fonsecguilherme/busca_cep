import 'package:bloc/bloc.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';

import '../../../core/commons/app_strings.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({
    required this.sharedServices,
  }) : super(const InitialFavoriteState());

  final SharedServices sharedServices;
  List<FavoriteModel> addressList = [];

  Future<void> loadFavoriteAdresses() async {
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    if (addressList.isEmpty) {
      emit(const InitialFavoriteState());
      return;
    }

    emit(LoadFavoriteZipState(addresses: addressList));
  }

  Future<void> deleteAddress(FavoriteModel address) async {
    addressList =
        await sharedServices.getListString(SharedPreferencesKeys.savedAdresses);

    addressList.removeWhere(
        (element) => element.addressModel.cep == address.addressModel.cep);

    await sharedServices.saveListString(
        SharedPreferencesKeys.savedAdresses, addressList);

    emit(const DeletedFavoriteZipState(AppStrings.deletedFavoriteZipText));
    if (addressList.isEmpty) {
      emit(const InitialFavoriteState());
      return;
    }

    emit(const LoadFavoriteZipState().copyWith(
      addresses: addressList,
    ));
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

      emit(AddedTagZipState(
        AppStrings.addTagSuccessText,
        address.tags,
      ));

      emit(const LoadFavoriteZipState().copyWith(
        addresses: addressList,
      ));
      return;
    }

    if (favoriteAddress.tags.contains(tag)) {
      address.tags.remove(tag);
      address.copyWith(tags: favoriteAddress.tags);

      await sharedServices.saveListString(
          SharedPreferencesKeys.savedAdresses, addressList);

      emit(RemovedTagZipState(AppStrings.removeTagSuccessText, address.tags));

      emit(const LoadFavoriteZipState().copyWith(
        addresses: addressList,
      ));
      return;
    }
  }

  Future<void> filterAddresses({
    required String query,
  }) async {
    final filteredList = addressList.where(
      (element) {
        return element.addressModel.cep.toLowerCase().contains(query) ||
            element.addressModel.logradouro.toLowerCase().contains(query) ||
            element.addressModel.complemento.toLowerCase().contains(query) ||
            element.addressModel.bairro.toLowerCase().contains(query) ||
            element.addressModel.localidade.toLowerCase().contains(query) ||
            element.addressModel.uf.toLowerCase().contains(query) ||
            element.addressModel.ddd.toLowerCase().contains(query);
      },
    ).toList();

    emit(const LoadFavoriteZipState().copyWith(
      filteredAddresses: filteredList,
    ));
  }

  Future<void> toggleAppBar({
    required AppBarType newAppBarType,
  }) async {
    emit(const LoadFavoriteZipState().copyWith(
      appBarType: newAppBarType,
    ));
  }
}

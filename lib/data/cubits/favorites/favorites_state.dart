import 'package:zip_search/model/address_model.dart';

abstract class FavoritesState {}

class InitialFavoriteState extends FavoritesState {}

class LoadFavoriteZipState extends FavoritesState {
  final List<AddressModel> addresses;

  LoadFavoriteZipState(this.addresses);

  //! create state to show when address is removed successfully
}

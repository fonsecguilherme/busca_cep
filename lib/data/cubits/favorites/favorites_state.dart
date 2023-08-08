import 'package:zip_search/model/address_model.dart';

abstract class FavoritesState {}

class InitialSearchZipState extends FavoritesState {}

class LoadedZipState extends FavoritesState {
  final List<AddressModel> addresses;

  LoadedZipState(this.addresses);
}

class ErrorZipState extends FavoritesState {
  final List<AddressModel> addresses;
  final String errorMessage;

  ErrorZipState(this.errorMessage, this.addresses);
}

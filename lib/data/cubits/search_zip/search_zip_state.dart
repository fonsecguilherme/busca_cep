import 'package:zip_search/model/address_model.dart';

abstract class SearchZipState {}

class InitialSearchZipState extends SearchZipState {}

class LoadingSearchZipState extends SearchZipState {}

class FetchedSearchZipState extends SearchZipState {
  final AddressModel address;

  FetchedSearchZipState(this.address);
}

class FavoritedAddressZipState extends SearchZipState {
  final String message;

  FavoritedAddressZipState({required this.message});
}

class ErrorSearchZipState extends SearchZipState {
  final String errorMessage;

  ErrorSearchZipState({required this.errorMessage});
}

class ErrorAlreadyAddedZipState extends SearchZipState {
  final String errorMessage;

  ErrorAlreadyAddedZipState({required this.errorMessage});
}

import 'package:zip_search/model/address_model.dart';

abstract class SearchZipState {}

class InitialSearchZipState extends SearchZipState {}

class LoadingSearchZipState extends SearchZipState {}

class FetchedSearchZipState extends SearchZipState {
  final AddressModel address;

  FetchedSearchZipState(this.address);
}

class ErrorSearchZipState extends SearchZipState {
  final String errorMessage;

  ErrorSearchZipState(this.errorMessage);
}

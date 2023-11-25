import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

abstract class SearchZipState extends Equatable {
  @override
  @override
  List<Object> get props => [];
}

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

class ErrorEmptyZipState extends SearchZipState {
  final String errorEmptyMessage;

  ErrorEmptyZipState({required this.errorEmptyMessage});
}

class ErrorAlreadyAddedZipState extends SearchZipState {
  final String errorMessage;

  ErrorAlreadyAddedZipState({required this.errorMessage});
}

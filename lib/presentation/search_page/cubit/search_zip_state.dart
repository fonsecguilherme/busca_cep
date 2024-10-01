import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

sealed class SearchZipState extends Equatable {
  @override
  List<Object> get props => [];
}

final class InitialSearchZipState extends SearchZipState {}

final class LoadingSearchZipState extends SearchZipState {}

final class FetchedSearchZipState extends SearchZipState {
  final AddressModel address;

  FetchedSearchZipState(this.address);
}

final class FavoritedAddressZipState extends SearchZipState {
  final String message;

  FavoritedAddressZipState({required this.message});
}

final class ErrorSearchZipState extends SearchZipState {
  final String errorMessage;

  ErrorSearchZipState({required this.errorMessage});
}

final class ErrorEmptyZipState extends SearchZipState {
  final String errorEmptyMessage;

  ErrorEmptyZipState({required this.errorEmptyMessage});
}

final class ErrorAlreadyAddedZipState extends SearchZipState {
  final String errorMessage;

  ErrorAlreadyAddedZipState({required this.errorMessage});
}

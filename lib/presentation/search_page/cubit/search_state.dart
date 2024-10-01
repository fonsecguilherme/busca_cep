import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

sealed class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

final class InitialSearchState extends SearchState {}

final class LoadingSearchState extends SearchState {}

final class SuccessSearchState extends SearchState {
  final AddressModel address;

  SuccessSearchState(this.address);
}

final class FavoriteAddressState extends SearchState {
  final String message;

  FavoriteAddressState({required this.message});
}

final class ErrorSearchZipState extends SearchState {
  final String errorMessage;

  ErrorSearchZipState({required this.errorMessage});
}

final class ErrorEmptyZipState extends SearchState {
  final String errorEmptyMessage;

  ErrorEmptyZipState({required this.errorEmptyMessage});
}

final class ErrorAlreadyFavotiteZipState extends SearchState {
  final String errorMessage;

  ErrorAlreadyFavotiteZipState({required this.errorMessage});
}

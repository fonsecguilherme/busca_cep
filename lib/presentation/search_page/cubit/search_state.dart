import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

enum SearchOptions { address, zip }

sealed class SearchState extends Equatable {
  final SearchOptions selectedOption;

  const SearchState({
    this.selectedOption = SearchOptions.zip,
  });

  @override
  List<Object> get props => [selectedOption];
}

final class InitialSearchState extends SearchState {
  const InitialSearchState({
    SearchOptions searchOption = SearchOptions.zip,
  }) : super(selectedOption: searchOption);
}

final class LoadingSearchState extends SearchState {}

final class SuccessSearchState extends SearchState {
  final AddressModel address;

  const SuccessSearchState(this.address);
}

final class SuccessAddressesSearchState extends SearchState {
  final List<AddressModel> addressList;

  const SuccessAddressesSearchState(this.addressList) : super();

  @override
  List<Object> get props => [addressList];
}

final class FavoriteAddressState extends SearchState {
  final String message;

  const FavoriteAddressState({required this.message});
}

// Error states

final class ErrorSearchZipState extends SearchState {
  final String errorMessage;

  const ErrorSearchZipState({required this.errorMessage});
}

final class ErrorEmptyZipState extends SearchState {
  final String errorEmptyMessage;

  const ErrorEmptyZipState({required this.errorEmptyMessage});
}

final class ErrorAlreadyFavotiteZipState extends SearchState {
  final String errorMessage;

  const ErrorAlreadyFavotiteZipState({required this.errorMessage});
}

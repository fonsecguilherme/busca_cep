import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/favorite_model.dart';

enum AppBarType { normal, search }

sealed class FavoriteState extends Equatable {
  final List<FavoriteModel> addresses;
  final List<FavoriteModel> filteredAddresses;

  const FavoriteState({
    this.addresses = const [],
    this.filteredAddresses = const [],
  });

  @override
  List<Object> get props => [addresses, filteredAddresses];
}

/// Page States
final class InitialFavoriteState extends FavoriteState {
  const InitialFavoriteState({
    List<FavoriteModel> addresses = const [],
    List<FavoriteModel> filteredAddresses = const [],
  }) : super(
          addresses: addresses,
          filteredAddresses: filteredAddresses,
        );
}

final class LoadFavoriteZipState extends FavoriteState {
  final AppBarType appBarType;

  const LoadFavoriteZipState({
    List<FavoriteModel> addresses = const [],
    List<FavoriteModel> filteredAddresses = const [],
    this.appBarType = AppBarType.normal,
  }) : super(
          addresses: addresses,
          filteredAddresses: filteredAddresses,
        );

  LoadFavoriteZipState copyWith({
    List<FavoriteModel>? addresses,
    List<FavoriteModel>? filteredAddresses,
    AppBarType? appBarType,
  }) {
    return LoadFavoriteZipState(
      addresses: addresses ?? this.addresses,
      filteredAddresses: filteredAddresses ?? this.filteredAddresses,
      appBarType: appBarType ?? this.appBarType,
    );
  }
}

/// SnackBar States
final class DeletedFavoriteZipState extends FavoriteState {
  final String deletedMessage;

  const DeletedFavoriteZipState(this.deletedMessage);
}

final class AddedTagZipState extends FavoriteState {
  final List<String> tags;
  final String message;

  const AddedTagZipState(this.message, this.tags);
}

final class RemovedTagZipState extends FavoriteState {
  final List<String> tags;
  final String message;

  const RemovedTagZipState(this.message, this.tags);
}

import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

sealed class FavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

final class InitialFavoriteState extends FavoritesState {}

final class LoadFavoriteZipState extends FavoritesState {
  late final List<AddressModel> addresses;

  LoadFavoriteZipState(this.addresses);

  @override
  List<Object> get props => [addresses];
}

final class DeletedFavoriteZipState extends FavoritesState {
  final String deletedMessage;

  DeletedFavoriteZipState(this.deletedMessage);
}

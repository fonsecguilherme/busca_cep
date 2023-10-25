import 'package:equatable/equatable.dart';
import 'package:zip_search/model/address_model.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialFavoriteState extends FavoritesState {}

class LoadFavoriteZipState extends FavoritesState {
  late final List<AddressModel> addresses;

  LoadFavoriteZipState(this.addresses);
}

class DeletedFavoriteZipState extends FavoritesState {
  final String deletedMessage;

  DeletedFavoriteZipState(this.deletedMessage);
}

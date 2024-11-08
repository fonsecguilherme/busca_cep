import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/favorite_model.dart';

sealed class FavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

final class InitialFavoriteState extends FavoriteState {}

final class LoadFavoriteZipState extends FavoriteState {
  late final List<FavoriteModel> addresses;

  LoadFavoriteZipState(this.addresses);

  @override
  List<Object> get props => [addresses];
}

final class DeletedFavoriteZipState extends FavoriteState {
  final String deletedMessage;

  DeletedFavoriteZipState(this.deletedMessage);
}

final class AddedTagZipState extends FavoriteState {
  final List<String> tags;
  final String message;

  AddedTagZipState(this.message, this.tags);
}

final class RemovedTagZipState extends FavoriteState {
  final List<String> tags;
  final String message;

  RemovedTagZipState(this.message, this.tags);
}

import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/favorite_model.dart';

sealed class FavoriteState extends Equatable {
  final List<FavoriteModel> addresses;

  const FavoriteState({this.addresses = const []});

  @override
  List<Object> get props => [addresses];
}

final class InitialFavoriteState extends FavoriteState {
  const InitialFavoriteState({super.addresses = const []});
}

final class LoadFavoriteZipState extends FavoriteState {
  const LoadFavoriteZipState(List<FavoriteModel> addresses)
      : super(addresses: addresses);
}

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

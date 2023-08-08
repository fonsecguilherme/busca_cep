import 'package:bloc/bloc.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(InitialSearchZipState());

  int counterValue = 0;
  final List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  void addToFavorites(AddressModel address) {
    if (_addressList.contains(address)) {
      emit(
        ErrorZipState(
            'Ops! Parece que esse endereço já foi adiconado', _addressList),
      );
    } else {
      _addressList.add(address);
      counterValue++;
      emit(LoadedZipState(_addressList));
    }
  }
}

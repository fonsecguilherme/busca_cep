import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';

class FavoritesZipPAge extends StatefulWidget {
  const FavoritesZipPAge({super.key});

  @override
  State<FavoritesZipPAge> createState() => _SavedZipState();
}

class _SavedZipState extends State<FavoritesZipPAge> {
  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<FavoritesCubit, FavoritesState>(
          bloc: favoritesCubit,
          listener: listener,
          builder: builder,
        ),
      );

  void listener(BuildContext context, FavoritesState state) {
    if (state is DeletedFavoriteZipState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(state.deletedMessage),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Widget builder(BuildContext context, FavoritesState state) {
    if (state is InitialFavoriteState) {
      return const Center(
        child: Text(AppStrings.initialZipPageText),
      );
    }
    if (state is LoadFavoriteZipState) {
      return _loadedAddresses(state.addresses);
    }
    return const SizedBox();
  }

  Widget _loadedAddresses(List<AddressModel> addressList) => ListView.builder(
        itemCount: addressList.length,
        itemBuilder: (context, index) {
          final address = addressList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address.cep,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            favoritesCubit.deleteAddress(addressList, address);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        _addressText(address),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  String _addressText(AddressModel address) =>
      '${address.logradouro},\n${_complementField(address.complemento)},'
      '\nBairro: ${address.bairro},\nDDD: ${address.ddd},'
      '\n${address.localidade}, ${address.uf}';

  String _complementField(String complement) {
    return complement.isEmpty ? AppStrings.emptyComplementText : complement;
  }
}

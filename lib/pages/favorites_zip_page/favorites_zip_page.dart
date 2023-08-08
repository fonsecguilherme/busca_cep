import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          listener: (context, state) {
            //! flushBar when address is removed successfully
          },
          builder: (context, state) {
            if (state is InitialFavoriteState) {
              return const Center(
                child: Text('Nenhum CEP foi favoritado!'),
              );
            } else if (state is LoadFavoriteZipState) {
              return _loadedAddresses(state.addresses);
            }
            return const SizedBox();
          },
        ),
      );

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
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.cep),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    '${address.logradouro}\n${address.complemento}'
                    '\nBairro: ${address.bairro},\nDDD: ${address.ddd},'
                    '\n${address.localidade}, ${address.uf}',
                  ),
                ),
              ],
            )),
          );
        },
      );
}

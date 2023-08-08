import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';
import 'package:zip_search/model/address_model.dart';

class SavedZipPage extends StatefulWidget {
  const SavedZipPage({super.key});

  @override
  State<SavedZipPage> createState() => _SavedZipState();
}

class _SavedZipState extends State<SavedZipPage> {
  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<FavoritesCubit, FavoritesState>(
          bloc: favoritesCubit,
          listener: (context, state) {
            if (state is ErrorZipState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is InitialSearchZipState) {
              return const Center(
                child: Text('Nenhum CEP foi favoritado!'),
              );
            } else if (state is LoadedZipState) {
              return _loadedAddresses(state.addresses);
            }
            return _loadedAddresses(favoritesCubit.addressList);
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

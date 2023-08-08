import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/model/address_model.dart';

class AddFavoritesButton extends StatefulWidget {
  final AddressModel address;

  const AddFavoritesButton({super.key, required this.address});

  @override
  State<AddFavoritesButton> createState() => _AddFavoritesButtonState();
}

class _AddFavoritesButtonState extends State<AddFavoritesButton> {
  FavoritesCubit get cubit => context.read<FavoritesCubit>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        cubit.addToFavorites(widget.address);
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded),
          SizedBox(width: 5),
          Text('Adicionar aos favoritos'),
        ],
      ),
    );
  }
}

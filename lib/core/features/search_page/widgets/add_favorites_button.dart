import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/model/address_model.dart';

class AddFavoritesButton extends StatefulWidget {
  final AddressModel address;

  const AddFavoritesButton({
    super.key,
    required this.address,
  });

  @override
  State<AddFavoritesButton> createState() => _AddFavoritesButtonState();
}

class _AddFavoritesButtonState extends State<AddFavoritesButton> {
  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();
  SearchZipCubit get searchZipCubit => context.read<SearchZipCubit>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await searchZipCubit.addToFavorites(widget.address);

        await favoritesCubit.loadFavoriteAdresses();
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded),
          SizedBox(width: 5),
          Text(AppStrings.addToFavoritesButton),
        ],
      ),
    );
  }
}

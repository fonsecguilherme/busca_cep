import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/extensions.dart';
import 'package:zip_search/core/commons/messages.dart';
import 'package:zip_search/core/model/address_model.dart';

import '../../favorite_page/cubit/favorite_cubit.dart';
import '../../favorite_page/cubit/favorite_state.dart';
import '../cubit/search_cubit.dart';

class AddressListWidget extends StatefulWidget {
  final List<AddressModel> addressList;

  const AddressListWidget({
    super.key,
    required this.addressList,
  });

  @override
  State<AddressListWidget> createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends State<AddressListWidget> {
  FavoriteCubit get favoritesCubit => context.read<FavoriteCubit>();
  SearchCubit get searchZipCubit => context.read<SearchCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppStrings.resultsAppBarText,
        ),
      ),
      body: ListView.separated(
        itemCount: widget.addressList.length,
        itemBuilder: (context, index) {
          final address = widget.addressList.elementAt(index);

          return ListTile(
            title: Text(
              address.cep,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(''.formatAddress(address)),
            trailing: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                final isFavorite = searchZipCubit.isAddresslreadyFavorited(
                  address: address,
                  addressList: state.addresses,
                );

                return IconButton(
                  onPressed: isFavorite
                      ? () {
                          Messages.of(context).showError(
                            AppStrings.favoritedAddressList,
                          );
                        }
                      : () async {
                          await searchZipCubit.addToFavorites(address);

                          await favoritesCubit.loadFavoriteAdresses();
                        },
                  icon: isFavorite
                      ? const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                        )
                      : const Icon(
                          CupertinoIcons.heart,
                        ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

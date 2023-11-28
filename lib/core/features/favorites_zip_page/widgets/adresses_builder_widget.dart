import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/favorites_zip_page/favorites_zip_page.dart';
import 'package:zip_search/core/model/address_model.dart';

class AdressesBuilderWidget extends StatelessWidget {
  final List<AddressModel> addressList;
  final FavoritesCubit favoritesCubit;

  const AdressesBuilderWidget({
    super.key,
    required this.addressList,
    required this.favoritesCubit,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        key: FavoritesZipPAge.loadedFavoriteAdressesKey,
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
                          onPressed: () => _showAdaptiveDialog(
                            context,
                            title: const Text(AppStrings.dialogTitleText),
                            content: const Text(
                              AppStrings.dialogContentText,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  favoritesCubit.deleteAddress(
                                    address,
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text(AppStrings.okText),
                              ),
                            ],
                          ),
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
      '\nBairro: ${address.bairro},'
      '\n${address.localidade}, ${address.uf}';

  String _complementField(String complement) {
    return complement.isEmpty ? AppStrings.emptyComplementText : complement;
  }

  void _showAdaptiveDialog(
    context, {
    required Text title,
    required Text content,
    required List<Widget> actions,
  }) {
    Platform.isIOS || Platform.isMacOS
        ? showCupertinoDialog<String>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: title,
              content: content,
              actions: actions,
            ),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: title,
              content: content,
              actions: actions,
            ),
          );
  }
}

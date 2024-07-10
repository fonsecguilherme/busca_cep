import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zip_search/core/commons/analytics_events.dart';
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
  Widget build(BuildContext context) {
    final analytics = FirebaseAnalytics.instance;

    return ListView.builder(
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
                        onPressed: () {
                          analytics.logEvent(
                              name:
                                  FavoritesPageEvents.favoritesPageDeleteButton,
                              parameters: <String, String>{
                                'zip': address.cep,
                                'ddd': address.ddd,
                                'address': address.logradouro,
                                'state': address.uf,
                              });

                          _showAdaptiveDialog(
                            context,
                            title: const Text(AppStrings.dialogTitleText),
                            content: const Text(
                              AppStrings.dialogContentText,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(AppStrings.cancelText),
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
                          );
                        },
                        icon: const InkWell(
                          child: Icon(CupertinoIcons.delete),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _addressText(address),
                      ),
                      IconButton(
                        onPressed: () {
                          analytics.logEvent(
                              name:
                                  FavoritesPageEvents.favoritesPageShareButton,
                              parameters: <String, String>{
                                'zip': address.cep,
                                'ddd': address.ddd,
                                'address': address.logradouro,
                                'state': address.uf,
                              });

                          Share.share(
                            _addressText(address),
                            subject: AppStrings.modalTitle,
                          );
                        },
                        icon: const Icon(CupertinoIcons.share),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

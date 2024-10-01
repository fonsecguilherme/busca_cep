import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zip_search/core/commons/analytics_events.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/extensions.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/presentation/favorites_zip_page/favorites_zip_page.dart';
import 'package:zip_search/core/model/address_model.dart';

class AdressesBuilderWidget extends StatelessWidget {
  final List<AddressModel> addressList;
  final FavoritesCubit favoritesCubit;
  final FirebaseAnalytics analytics;

  const AdressesBuilderWidget({
    super.key,
    required this.addressList,
    required this.favoritesCubit,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: FavoritesZipPAge.loadedFavoriteAdressesKey,
      itemCount: addressList.length,
      itemBuilder: (context, index) {
        final address = addressList.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                          fontSize: 16,
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
                        icon: InkWell(
                          child: Icon(
                            CupertinoIcons.delete,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          ''.favoriteCardAddressFormat(address),
                        ),
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
                            ''.favoriteCardAddressFormat(address),
                            subject: AppStrings.modalTitle,
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.share,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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

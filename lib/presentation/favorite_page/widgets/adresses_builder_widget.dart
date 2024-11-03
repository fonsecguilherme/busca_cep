import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zip_search/core/commons/analytics_events.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/extensions.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/favorite_page.dart';
import 'package:zip_search/presentation/favorite_page/widgets/tag_builder_widget.dart';

class AdressesBuilderWidget extends StatelessWidget {
  final List<FavoriteModel> addressList;
  final FavoriteCubit favoritesCubit;
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
      key: FavoritePage.loadedFavoriteAdressesKey,
      itemCount: addressList.length,
      itemBuilder: (context, index) {
        //! para cada endereço desse eu vou pegar quantas tags ele tem
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
                        address.addressModel.cep,
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
                                'zip': address.addressModel.cep,
                                'ddd': address.addressModel.ddd,
                                'address': address.addressModel.logradouro,
                                'state': address.addressModel.uf,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ''.favoriteCardAddressFormat(
                                address.addressModel,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            TagBuilderWidget(favoriteAddress: address),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          analytics.logEvent(
                              name:
                                  FavoritesPageEvents.favoritesPageShareButton,
                              parameters: <String, String>{
                                'zip': address.addressModel.cep,
                                'ddd': address.addressModel.ddd,
                                'address': address.addressModel.logradouro,
                                'state': address.addressModel.uf,
                              });

                          Share.share(
                            ''.favoriteCardAddressFormat(address.addressModel),
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

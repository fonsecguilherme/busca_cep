import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/extensions.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/presentation/search_page/widgets/add_favorites_button.dart';
import 'package:zip_search/presentation/search_page/widgets/initial_widget.dart';

class SuccessWidget extends StatelessWidget {
  final AddressModel address;
  final FirebaseAnalytics analytics;

  static const addressFoundWidgetKey = Key('addressFoundWidgetKey');

  const SuccessWidget({
    super.key,
    required this.address,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        key: SuccessWidget.addressFoundWidgetKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InitialWidget(analytics: analytics),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 18,
                right: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.addressText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ''.formatAddress(address),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            AddFavoritesButton(
              address: address,
              analytics: analytics,
            ),
          ],
        ),
      );
}

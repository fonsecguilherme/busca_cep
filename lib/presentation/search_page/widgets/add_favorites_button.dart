import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/presentation/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/core/widgets/custom_elevated_button.dart';

import '../../../core/commons/analytics_events.dart';

class AddFavoritesButton extends StatefulWidget {
  final AddressModel address;
  final FirebaseAnalytics analytics;

  const AddFavoritesButton({
    super.key,
    required this.address,
    required this.analytics,
  });

  @override
  State<AddFavoritesButton> createState() => _AddFavoritesButtonState();
}

class _AddFavoritesButtonState extends State<AddFavoritesButton> {
  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();
  SearchZipCubit get searchZipCubit => context.read<SearchZipCubit>();

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      icon: CupertinoIcons.star,
      title: AppStrings.addToFavoritesButton,
      onTap: () async {
        await searchZipCubit.addToFavorites(widget.address);

        await favoritesCubit.loadFavoriteAdresses();

        widget.analytics.logEvent(
          name: SearchPageEvents.searchPageAddFavoriteButton,
          parameters: <String, String>{
            'zip': widget.address.cep,
            'ddd': widget.address.ddd,
            'address': widget.address.logradouro,
            'state': widget.address.uf,
          },
        );
      },
    );
  }
}

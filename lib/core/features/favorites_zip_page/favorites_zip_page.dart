import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/messages.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/features/favorites_zip_page/widgets/adresses_builder_widget.dart';

import '../../di/setup_locator.dart';

class FavoritesZipPAge extends StatefulWidget {
  const FavoritesZipPAge({super.key});

  static const loadedFavoriteAdressesKey = Key('loadedFavoriteAdressesKey');

  @override
  State<FavoritesZipPAge> createState() => _SavedZipState();
}

class _SavedZipState extends State<FavoritesZipPAge> {
  @override
  void initState() {
    super.initState();
    favoritesCubit.loadFavoriteAdresses();
  }

  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();
  final analytics = getIt<FirebaseAnalytics>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocConsumer<FavoritesCubit, FavoritesState>(
          bloc: favoritesCubit,
          listener: listener,
          builder: builder,
        ),
      );

  void listener(BuildContext context, FavoritesState state) {
    if (state is DeletedFavoriteZipState) {
      Messages.of(context).showSuccess(state.deletedMessage);
    }
  }

  Widget builder(BuildContext context, FavoritesState state) {
    if (state is InitialFavoriteState) {
      return const Center(
        child: Text(AppStrings.initialZipPageText),
      );
    }
    if (state is LoadFavoriteZipState) {
      return AdressesBuilderWidget(
        addressList: state.addresses,
        favoritesCubit: favoritesCubit,
        analytics: analytics,
      );
    }
    return const SizedBox();
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/messages.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';
import 'package:zip_search/presentation/favorite_page/widgets/adresses_builder_widget.dart';

import '../../core/di/setup_locator.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  static const loadedFavoriteAdressesKey = Key('loadedFavoriteAdressesKey');

  @override
  State<FavoritePage> createState() => _SavedZipState();
}

class _SavedZipState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    favoritesCubit.loadFavoriteAdresses();
  }

  FavoriteCubit get favoritesCubit => context.read<FavoriteCubit>();
  final analytics = getIt<FirebaseAnalytics>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocConsumer<FavoriteCubit, FavoriteState>(
          bloc: favoritesCubit,
          listener: listener,
          builder: builder,
        ),
      );

  void listener(BuildContext context, FavoriteState state) {
    if (state is DeletedFavoriteZipState) {
      Messages.of(context).showSuccess(state.deletedMessage);
    }
  }

  Widget builder(BuildContext context, FavoriteState state) {
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

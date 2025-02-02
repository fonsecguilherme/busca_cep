// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/favorite_page.dart';

import '../../../core/commons/app_strings.dart';
import '../cubit/favorite_state.dart';
import 'custom_favorite_card.dart';

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
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        List<FavoriteModel> myList = [];

        myList = addressesListing(state);

        return Scaffold(
          appBar: _CustomSearchAppBar(
            favoriteCubit: favoritesCubit,
          ),
          body: ListView.builder(
            key: FavoritePage.loadedFavoriteAdressesKey,
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final address = myList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: CustomFavoriteCardWidget(
                  address: address,
                  analytics: analytics,
                  favoritesCubit: favoritesCubit,
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<FavoriteModel> addressesListing(FavoriteState state) {
    if (state.filteredAddresses.isNotEmpty) {
      return state.filteredAddresses;
    } else {
      return state.addresses;
    }
  }
}

class _CustomSearchAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final FavoriteCubit favoriteCubit;

  const _CustomSearchAppBar({
    required this.favoriteCubit,
  });

  @override
  State<_CustomSearchAppBar> createState() => __CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class __CustomSearchAppBarState extends State<_CustomSearchAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is RemovedTagZipState || state is RemovedTagZipState) {
          _searchController.clear();
        }
      },
      builder: (context, state) {
        if (state is LoadFavoriteZipState) {
          return state.appBarType == AppBarType.search
              ? SearchAppBarWidget(
                  favoriteCubit: widget.favoriteCubit,
                  controller: _searchController,
                )
              : DefaultAppBar(
                  favoriteCubit: widget.favoriteCubit,
                  controller: _searchController,
                );
        } else {
          return const Center(child: Text('deu ruim'));
        }
      },
    );
  }
}

class DefaultAppBar extends StatefulWidget {
  final FavoriteCubit favoriteCubit;
  final TextEditingController controller;

  const DefaultAppBar({
    Key? key,
    required this.favoriteCubit,
    required this.controller,
  }) : super(key: key);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.search),
          onPressed: () {
            widget.favoriteCubit.toggleAppBar(
              newAppBarType: AppBarType.search,
            );
          },
        ),
      ],
    );
  }
}

class SearchAppBarWidget extends StatefulWidget {
  final FavoriteCubit favoriteCubit;
  final TextEditingController controller;

  const SearchAppBarWidget({
    Key? key,
    required this.favoriteCubit,
    required this.controller,
  }) : super(key: key);

  @override
  State<SearchAppBarWidget> createState() => _SearchAppBarWidgetState();
}

class _SearchAppBarWidgetState extends State<SearchAppBarWidget> {
  @override
  Widget build(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.favoriteCubit.toggleAppBar(
              newAppBarType: AppBarType.normal,
            );
            widget.controller.clear();
          },
        ),
        title: TextField(
          controller: widget.controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: AppStrings.searchText,
            border: InputBorder.none,
          ),
          onChanged: (query) {
            widget.favoriteCubit.filterAddresses(
              query: query,
            );
          },
        ),
      );
}

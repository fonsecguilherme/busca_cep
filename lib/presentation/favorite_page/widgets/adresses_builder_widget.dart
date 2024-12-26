import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/favorite_page.dart';

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
        return Scaffold(
          appBar: _CustomSearchAppBar(
            favoritesCubit: favoritesCubit,
          ),
          body: ListView.builder(
            key: FavoritePage.loadedFavoriteAdressesKey,
            itemCount: state.addresses.length,
            itemBuilder: (context, index) {
              final address = addressList.elementAt(index);
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
}

class _CustomSearchAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final FavoriteCubit favoritesCubit;

  const _CustomSearchAppBar({
    required this.favoritesCubit,
  });

  @override
  State<_CustomSearchAppBar> createState() => __CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class __CustomSearchAppBarState extends State<_CustomSearchAppBar> {
  late AppBartype appBartype;
  final TextEditingController _searchController = TextEditingController();

  AppBar _buildDefaultAppBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.search),
          onPressed: () {
            setState(() {
              appBartype = AppBartype.searchAppBar;
              _searchController.clear();
            });
          },
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            appBartype = AppBartype.defaultAppBar;
            _searchController.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Buscar...',
          border: InputBorder.none,
        ),
        onChanged: (query) {
          widget.favoritesCubit.filterAddresses(
            query: query,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appBartype = widget.favoritesCubit.appBarType;
    setState(() {
      appBartype = AppBartype.defaultAppBar;
      _searchController.clear();
      print('Conteúdo ${_searchController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        return appBartype == AppBartype.searchAppBar
            ? _buildSearchAppBar()
            : _buildDefaultAppBar();
      },
    );
  }
}

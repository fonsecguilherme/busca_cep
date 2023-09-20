import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/navigation/naviagtion_state.dart';
import 'package:zip_search/data/cubits/navigation/navigation_cubit.dart';
import 'package:zip_search/pages/counter_page/counter_page.dart';
import 'package:zip_search/pages/favorites_zip_page/favorites_zip_page.dart';
import 'package:zip_search/pages/search_page/search_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  NavigationCubit get navigationCubit => context.read<NavigationCubit>();
  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: _bottomNavigationWidget(),
        body: SafeArea(child: _body()),
      );

  Widget _bottomNavigationWidget() =>
      BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.index,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: AppStrings.navigationBarLabel01),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: AppStrings.navigationBarLabel02),
              BottomNavigationBarItem(
                  icon: Badge(
                    label: Text(
                      favoritesCubit.addressList.length.toString(),
                    ),
                    child: const Icon(
                      Icons.star_border_rounded,
                    ),
                  ),
                  label: AppStrings.navigationBarLabel03)
            ],
            onTap: (index) {
              if (index == 0) {
                navigationCubit.getNavBarItem(NavBarItem.counter);
              } else if (index == 1) {
                navigationCubit.getNavBarItem(NavBarItem.search);
              } else if (index == 2) {
                navigationCubit.getNavBarItem(NavBarItem.saved);
              }
            },
          );
        },
      );

  Widget _body() => BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          if (state.navBarItem == NavBarItem.counter) {
            return const CounterPage();
          } else if (state.navBarItem == NavBarItem.search) {
            return const SearchPage();
          } else if (state.navBarItem == NavBarItem.saved) {
            return const FavoritesZipPAge();
          }
          return const SizedBox();
        },
      );
}

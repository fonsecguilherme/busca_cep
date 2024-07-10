import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/counter_page/counter_page.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_state.dart';
import 'package:zip_search/core/features/favorites_zip_page/favorites_zip_page.dart';
import 'package:zip_search/core/features/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/core/features/navigation_page/cubit/navigation_state.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/search_page.dart';
import 'package:zip_search/domain/via_cep_repository.dart';

import '../../../data/shared_services.dart';
import '../../commons/analytics_events.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _RootPageState();
}

class _RootPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();

    favoritesCubit.loadFavoriteAdresses();
  }

  final repository = ViaCepRepository();
  FavoritesCubit get favoritesCubit => context.read<FavoritesCubit>();

  @override
  Widget build(BuildContext context) {
    final sharedServices = SharedServices();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchZipCubit(
            viaCepRepository: repository,
            sharedServices: sharedServices,
          ),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: _BottomNaVigationBarWidget(),
        body: SafeArea(child: _body()),
      ),
    );
  }

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

class _BottomNaVigationBarWidget extends StatelessWidget {
  _BottomNaVigationBarWidget();

  final analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return NavigationBar(
          animationDuration: const Duration(seconds: 1),
          elevation: 1,
          selectedIndex: state.index,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(CupertinoIcons.home),
              label: AppStrings.navigationBarLabel01,
            ),
            const NavigationDestination(
              icon: Icon(CupertinoIcons.search),
              label: AppStrings.navigationBarLabel02,
            ),
            NavigationDestination(
              icon: Badge(
                label: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (_, state) {
                    switch (state) {
                      case LoadFavoriteZipState s:
                        return Text('${s.addresses.length}');
                      default:
                        return const Text('0');
                    }
                  },
                ),
                child: const Icon(CupertinoIcons.star),
              ),
              label: AppStrings.navigationBarLabel03,
            ),
          ],
          onDestinationSelected: (index) {
            if (index == 0) {
              analytics.logEvent(
                  name: NavigationBarEvents.navigationToHomePage);

              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.counter);
            } else if (index == 1) {
              analytics.logEvent(
                  name: NavigationBarEvents.navigationToSearchPage);

              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.search);
            } else if (index == 2) {
              analytics.logEvent(
                  name: NavigationBarEvents.navigationToFavoritePage);

              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.saved);
            }
          },
        );
      },
    );
  }
}

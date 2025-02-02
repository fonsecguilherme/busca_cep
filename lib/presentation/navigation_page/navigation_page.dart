import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/widgets/focus_widget.dart';
import 'package:zip_search/domain/repositories/via_cep_repository.dart';
import 'package:zip_search/presentation/counter_page/counter_page.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';
import 'package:zip_search/presentation/favorite_page/favorite_page.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_state.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/search_page.dart';

import '../../core/di/setup_locator.dart';
import '../../data/shared_services.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  static const navigationBarStarIcon = Key('navigationBarStarIcon');

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();

    favoritesCubit.loadFavoriteAdresses();
  }

  FavoriteCubit get favoritesCubit => context.read<FavoriteCubit>();

  final repository = getIt<IViaCepRepository>();
  final sharedServices = getIt<SharedServices>();
  final analytics = getIt<FirebaseAnalytics>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchCubit(
            viaCepRepository: repository,
            sharedServices: sharedServices,
          ),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: FocusWidget(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: _BottomNaVigationBarWidget(
            analytics: analytics,
          ),
          body: SafeArea(
            child: BlocBuilder<NavigationCubit, NavigationState>(
              builder: (context, state) {
                if (state.navBarItem == NavBarItem.counter) {
                  return const CounterPage();
                } else if (state.navBarItem == NavBarItem.search) {
                  return const SearchPage();
                } else if (state.navBarItem == NavBarItem.saved) {
                  return const FavoritePage();
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNaVigationBarWidget extends StatelessWidget {
  final FirebaseAnalytics analytics;

  const _BottomNaVigationBarWidget({required this.analytics});

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
                label: BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (_, state) {
                    switch (state) {
                      case LoadFavoriteZipState s:
                        return Text('${s.addresses.length}');
                      default:
                        return const Text('0');
                    }
                  },
                ),
                child: const Icon(
                  CupertinoIcons.star,
                  key: NavigationPage.navigationBarStarIcon,
                ),
              ),
              label: AppStrings.navigationBarLabel03,
            ),
          ],
          onDestinationSelected: (index) {
            if (index == 0) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.counter);
            } else if (index == 1) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.search);
            } else if (index == 2) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.saved);
            }
          },
        );
      },
    );
  }
}

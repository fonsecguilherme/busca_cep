import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:zip_search/core/widgets/focus_widget.dart';
import 'package:zip_search/domain/repositories/via_cep_repository.dart';
import 'package:zip_search/presentation/counter_page/counter_page.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/favorite_page.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_state.dart';
import 'package:zip_search/presentation/navigation_page/widgets/navigation_bar_icon_with_badge_widget.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/search_page.dart';
import 'package:zip_search/presentation/theme/cubit/theme_cubit.dart';

import '../../core/commons/rive_utils.dart';
import '../../core/di/setup_locator.dart';
import '../../core/model/nav_item_model.dart';
import '../../data/shared_services.dart';
import 'widgets/navigation_bar_icon_widget.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  static const navigationBarStarIcon = Key('navigationBarStarIcon');

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final repository = getIt<IViaCepRepository>();
  final sharedServices = getIt<SharedServices>();
  final analytics = getIt<FirebaseAnalytics>();

  FavoriteCubit get favoritesCubit => context.read<FavoriteCubit>();

  int counterValue = 0;
  int favoriteValue = 0;

  @override
  void initState() {
    super.initState();

    favoritesCubit.loadFavoriteAdresses();
    favoritesCubit.updateCounterValues().then(
      (values) {
        counterValue = values.$1;
        favoriteValue = values.$2;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkThemeEnable = context.watch<ThemeCubit>().state.isDark;

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
        )
      ],
      child: FocusWidget(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          body: BlocConsumer<NavigationCubit, NavigationState>(
            listener: (context, state) {
              if (state.navBarItem == NavBarItem.counter) {
                favoritesCubit.updateCounterValues().then((values) {
                  setState(() {
                    counterValue = values.$1;
                    favoriteValue = values.$2;
                  });
                });
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  IndexedStack(
                    index: state.index,
                    children: [
                      CounterPage(
                        counterFav: counterValue,
                        counterSearch: favoriteValue,
                      ),
                      const SearchPage(),
                      const FavoritePage(),
                    ],
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24,
                        ),
                        margin: const EdgeInsets.only(
                            right: 48.0, bottom: 8, left: 48.0),
                        decoration: BoxDecoration(
                          color: isDarkThemeEnable
                              ? Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF17203A)
                                  .withValues(alpha: 0.3),
                              offset: const Offset(0, 20),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            bottomNavItems.length,
                            (index) {
                              final isSelected = index == state.index;

                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    bottomNavItems
                                        .elementAt(index)
                                        .input
                                        ?.change(true);
                                    if (!isSelected) {
                                      BlocProvider.of<NavigationCubit>(context)
                                          .getNavBarItem(NavBarItem.counter);
                                    }
                                    Future.delayed(
                                        const Duration(seconds: 1),
                                        () => bottomNavItems
                                            .elementAt(index)
                                            .input
                                            ?.change(false));
                                  } else if (index == 1) {
                                    bottomNavItems
                                        .elementAt(index)
                                        .input
                                        ?.change(true);
                                    if (!isSelected) {
                                      BlocProvider.of<NavigationCubit>(context)
                                          .getNavBarItem(NavBarItem.search);
                                    }
                                    Future.delayed(
                                        const Duration(seconds: 1),
                                        () => bottomNavItems
                                            .elementAt(index)
                                            .input
                                            ?.change(false));
                                  } else if (index == 2) {
                                    bottomNavItems
                                        .elementAt(index)
                                        .input
                                        ?.change(true);
                                    if (!isSelected) {
                                      BlocProvider.of<NavigationCubit>(context)
                                          .getNavBarItem(NavBarItem.saved);
                                    }
                                    Future.delayed(
                                        const Duration(seconds: 1),
                                        () => bottomNavItems
                                            .elementAt(index)
                                            .input
                                            ?.change(false));
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    switch (index) {
                                      0 => NavigationBarIconWidget(
                                          navigationState: state,
                                          selectedNavBarIndex: index,
                                          onInit: (artboard) {
                                            final controller =
                                                RiveUtils.getRiveController(
                                              artboard,
                                              stateMachineName: bottomNavItems
                                                  .elementAt(index)
                                                  .stateMachineName,
                                            );
                                            final input = controller
                                                .findSMI('active') as SMIBool;
                                            bottomNavItems
                                                .elementAt(index)
                                                .setInput = input;
                                          },
                                          icon: NavItemModel(
                                              title: bottomNavItems
                                                  .elementAt(index)
                                                  .title,
                                              rive: bottomNavItems
                                                  .elementAt(index)),
                                          iconText: bottomNavItems
                                              .elementAt(index)
                                              .title,
                                          iconPositionIndex: index,
                                          isDarkThemeEnable: isDarkThemeEnable,
                                        ),
                                      1 => NavigationBarIconWidget(
                                          navigationState: state,
                                          selectedNavBarIndex: index,
                                          onInit: (artboard) {
                                            final controller =
                                                RiveUtils.getRiveController(
                                              artboard,
                                              stateMachineName: bottomNavItems
                                                  .elementAt(index)
                                                  .stateMachineName,
                                            );
                                            final input = controller
                                                .findSMI('active') as SMIBool;
                                            bottomNavItems
                                                .elementAt(index)
                                                .setInput = input;
                                          },
                                          icon: NavItemModel(
                                              title: bottomNavItems
                                                  .elementAt(index)
                                                  .title,
                                              rive: bottomNavItems
                                                  .elementAt(index)),
                                          iconText: bottomNavItems
                                              .elementAt(index)
                                              .title,
                                          iconPositionIndex: index,
                                          isDarkThemeEnable: isDarkThemeEnable,
                                        ),
                                      2 => NavigationBarIconWithBadgeWidget(
                                          navigationState: state,
                                          selectedNavBarIndex: index,
                                          onInit: (artboard) {
                                            final controller =
                                                RiveUtils.getRiveController(
                                              artboard,
                                              stateMachineName: bottomNavItems
                                                  .elementAt(index)
                                                  .stateMachineName,
                                            );
                                            final input = controller
                                                .findSMI('active') as SMIBool;
                                            bottomNavItems
                                                .elementAt(index)
                                                .setInput = input;
                                          },
                                          icon: NavItemModel(
                                              title: bottomNavItems
                                                  .elementAt(index)
                                                  .title,
                                              rive: bottomNavItems
                                                  .elementAt(index)),
                                          iconText: bottomNavItems
                                              .elementAt(index)
                                              .title,
                                          iconPositionIndex: index,
                                          isDarkThemeEnable: isDarkThemeEnable,
                                        ),
                                      int() => throw UnimplementedError(),
                                    },
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

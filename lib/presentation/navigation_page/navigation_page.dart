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
  @override
  void initState() {
    super.initState();

    favoritesCubit.loadFavoriteAdresses();
  }

  FavoriteCubit get favoritesCubit => context.read<FavoriteCubit>();

  final repository = getIt<IViaCepRepository>();
  final sharedServices = getIt<SharedServices>();
  final analytics = getIt<FirebaseAnalytics>();

  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];

  void animateIcon(int index) {
    riveIconInputs.elementAt(index).change(true);

    Future.delayed(const Duration(seconds: 1), () {
      riveIconInputs.elementAt(index).change(false);
    });
  }

  void riveOnInit({
    required Artboard artboard,
    required String stateMachineName,
  }) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    if (controller != null) {
      artboard.addController(controller);

      controllers.add(controller);

      riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
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
          body: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              return Stack(
                children: [
                  IndexedStack(
                    index: state.index,
                    children: const [
                      CounterPage(),
                      SearchPage(),
                      FavoritePage(),
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
                            3,
                            (index) {
                              final icon = isDarkThemeEnable
                                  ? whiteBottomNavItems.elementAt(index)
                                  : bottomNavItems.elementAt(index);

                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    BlocProvider.of<NavigationCubit>(context)
                                        .getNavBarItem(NavBarItem.counter);
                                    animateIcon(index);
                                  } else if (index == 1) {
                                    BlocProvider.of<NavigationCubit>(context)
                                        .getNavBarItem(NavBarItem.search);
                                    animateIcon(index);
                                  } else if (index == 2) {
                                    BlocProvider.of<NavigationCubit>(context)
                                        .getNavBarItem(NavBarItem.saved);
                                    animateIcon(index);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    switch (index) {
                                      0 => NavigationBarIconWidget(
                                          navigationState: state,
                                          selectedNavBarIndex: index,
                                          onInit: (artboard) => riveOnInit(
                                            artboard: artboard,
                                            stateMachineName:
                                                icon.rive.stateMachine,
                                          ),
                                          icon: icon,
                                          iconText: 'Home',
                                          iconPositionIndex: index,
                                        ),
                                      1 => NavigationBarIconWidget(
                                          navigationState: state,
                                          selectedNavBarIndex: index,
                                          onInit: (artboard) => riveOnInit(
                                            artboard: artboard,
                                            stateMachineName:
                                                icon.rive.stateMachine,
                                          ),
                                          icon: icon,
                                          iconText: 'Buscar',
                                          iconPositionIndex: index,
                                        ),
                                      2 => NavigationBarIconWithBadgeWidget(
                                          navigationState: state,
                                          selectedNavBarIndex: index,
                                          onInit: (artboard) => riveOnInit(
                                            artboard: artboard,
                                            stateMachineName:
                                                icon.rive.stateMachine,
                                          ),
                                          icon: icon,
                                          iconText: 'Favoritos',
                                          iconPositionIndex: index,
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

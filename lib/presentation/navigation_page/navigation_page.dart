import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
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
import '../../core/model/nav_item_model.dart';
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
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];

  void animateIcon(int index) {
    riveIconInputs.elementAt(index).change(true);

    Future.delayed(const Duration(seconds: 1), () {
      riveIconInputs.elementAt(index).change(false);
    });
  }

  void riveOnInit(
      {required Artboard artboard, required String stateMachineName}) {
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
          // bottomNavigationBar: _BottomNaVigationBarWidget(
          //   analytics: analytics,
          // ),
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
                    bottom: 0,
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
                        color: Colors
                            .amber, //Theme.of(context).colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF17203A).withValues(alpha: 0.3),
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
                            final icon = whiteBottomNavItems.elementAt(index);

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
                                  Badge(
                                    label: BlocBuilder<FavoriteCubit,
                                        FavoriteState>(
                                      builder: (_, state) {
                                        switch (state) {
                                          case LoadFavoriteZipState s:
                                            return Text(
                                                '${s.addresses.length}');
                                          default:
                                            return const Text('0');
                                        }
                                      },
                                    ),
                                    child: SizedBox(
                                      height: 36,
                                      width: 36,
                                      child: Opacity(
                                        opacity: state.index == index ? 1 : 0.5,
                                        child: RiveAnimation.asset(
                                          icon.rive.src,
                                          artboard: icon.rive.artboard,
                                          onInit: (artboard) => riveOnInit(
                                            artboard: artboard,
                                            stateMachineName:
                                                icon.rive.stateMachine,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(state.navBarItem.name),
                                  AnimatedBar(
                                    isActive: state.index == index,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )),
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

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(
          bottom: 2.0,
        ),
        height: 4,
        width: isActive ? 20 : 0,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      );
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

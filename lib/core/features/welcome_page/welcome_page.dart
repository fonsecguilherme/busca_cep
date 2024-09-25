import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/navigation_page/navigation_page.dart';
import 'package:zip_search/core/features/welcome_page/widgets/welcome_page_item.dart';
import 'package:zip_search/core/widgets/custom_elevated_button.dart';
import 'package:zip_search/setup_locator.dart';

import '../../../data/shared_services.dart';
import '../../commons/analytics_events.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.prefs,
  });

  final SharedServices prefs;

  @override
  State<WelcomePage> createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  bool _isLastPage = false;
  final PageController _pageController = PageController();
  final analytics = getIt<FirebaseAnalytics>();

  @override
  void initState() {
    super.initState();
    widget.prefs.saveBool(SharedPreferencesKeys.boolKey, false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 13,
                child: PageView(
                  onPageChanged: (pageIndex) {
                    if (pageIndex == 3) {
                      _isLastPage = true;
                      setState(() {});
                    } else if (pageIndex == 2) {
                      _isLastPage = false;
                      setState(() {});
                    }
                  },
                  controller: _pageController,
                  children: const [
                    WelcomePageItem(
                      title: AppStrings.welcomePageItemTitle01,
                      message: AppStrings.welcomePageItemMessage01,
                    ),
                    WelcomePageItem(
                      title: AppStrings.welcomePageItemTitle02,
                      message: AppStrings.welcomePageItemMessage02,
                    ),
                    WelcomePageItem(
                      title: AppStrings.welcomePageItemTitle03,
                      message: AppStrings.welcomePageItemMessage03,
                    ),
                    WelcomePageItem(
                      title: AppStrings.welcomePageItemTitle04,
                      message: AppStrings.welcomePageItemMessage04,
                    ),
                  ],
                ),
              ),
              _LastPageButton(
                analytics: getIt<FirebaseAnalytics>(),
                isLastPage: _isLastPage,
                sharedServices: getIt<SharedServices>(),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 17.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: WormEffect(
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _LastPageButton extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final bool isLastPage;
  final SharedServices sharedServices;

  const _LastPageButton({
    required this.analytics,
    required this.isLastPage,
    required this.sharedServices,
  });

  @override
  Widget build(BuildContext context) => isLastPage == false
      ? const SizedBox(height: 44)
      : CustomElevatedButton(
          icon: CupertinoIcons.home,
          title: AppStrings.goToHomeButton,
          onTap: () {
            analytics.logEvent(name: FirstUseEvents.firstUseToHomePage);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => FavoritesCubit(
                    sharedServices: sharedServices,
                  ),
                  child: const NavigationPage(),
                ),
              ),
            );
          },
        );
}

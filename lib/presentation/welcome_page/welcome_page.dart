import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/presentation/welcome_page/widgets/welcome_page_item.dart';

import '../../core/di/setup_locator.dart';
import '../../data/shared_services.dart';
import 'widgets/last_page_button.dart';

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
  final sharedServices = getIt<SharedServices>();

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
              LastPageButton(
                analytics: analytics,
                isLastPage: _isLastPage,
                sharedServices: sharedServices,
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

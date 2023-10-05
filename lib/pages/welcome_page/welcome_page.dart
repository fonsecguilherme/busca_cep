import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/navigation/navigation_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/pages/root_page/root_page.dart';
import 'package:zip_search/pages/welcome_page/widgets/welcome_page_item.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  bool _isLastPage = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
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
              _lastPageButton(),
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

  Widget _lastPageButton() {
    return _isLastPage == false
        ? const SizedBox(height: 44)
        : ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const RootPage()),
              );
            },
            child: const Text('Ir para home'),
          );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

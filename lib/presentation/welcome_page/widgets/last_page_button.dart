import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/commons/analytics_events.dart';
import '../../../core/commons/app_strings.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../data/shared_services.dart';
import '../../favorite_page/cubit/export_favorite_cubit.dart';
import '../../navigation_page/navigation_page.dart';

class LastPageButton extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final bool isLastPage;
  final SharedServices sharedServices;

  const LastPageButton({
    super.key,
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
                  create: (context) => FavoriteCubit(
                    sharedServices: sharedServices,
                  ),
                  child: const NavigationPage(),
                ),
              ),
            );
          },
        );
}

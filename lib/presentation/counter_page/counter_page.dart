import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/counter_page/widgets/counter_bar_widget.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/theme/cubit/theme_cubit.dart';

import '../../core/commons/analytics_events.dart';
import '../../core/di/setup_locator.dart';

class CounterPage extends StatefulWidget {
  final int counterSearch;
  final int counterFav;

  const CounterPage({
    super.key,
    required this.counterSearch,
    required this.counterFav,
  });

  static const counterPageKey = Key('counterPageKey');

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final sharedServices = getIt<SharedServices>();
  final analytics = getIt<FirebaseAnalytics>();

  SearchCubit get searchZipCubit => context.read<SearchCubit>();
  ThemeCubit get themeCubit => context.read<ThemeCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: BlocBuilder<ThemeCubit, AppTheme>(
              builder: (context, state) {
                return Switch.adaptive(
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  value: state.isLight,
                  thumbIcon: themeCubit.thumbIcon,
                  onChanged: (_) => themeCubit.toggleTheme(),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        key: CounterPage.counterPageKey,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.greetingsText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            CounterBarWidget(
              value: widget.counterSearch,
              icon: CupertinoIcons.checkmark,
              text: AppStrings.successfulSearchedZipsText,
              onTap: () =>
                  analytics.logEvent(name: CounterPageEvents.searchedZipCard),
            ),
            CounterBarWidget(
              value: widget.counterFav,
              icon: CupertinoIcons.star,
              text: AppStrings.successfulSavedZipsText,
              onTap: () =>
                  analytics.logEvent(name: CounterPageEvents.favoritedZipCard),
            ),
            const SizedBox(
              height: 94,
            )
          ],
        ),
      ),
    );
  }
}

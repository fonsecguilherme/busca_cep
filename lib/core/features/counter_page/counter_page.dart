import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/features/counter_page/widgets/counter_bar_widget.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/theme/cubit/theme_cubit.dart';
import 'package:zip_search/data/shared_services.dart';

import '../../commons/analytics_events.dart';
import '../../di/setup_locator.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  static const counterPageKey = Key('counterPageKey');

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counterSearch = 0;
  int counterFav = 0;

  final sharedServices = getIt<SharedServices>();
  final analytics = getIt<FirebaseAnalytics>();

  SearchZipCubit get searchZipCubit => context.read<SearchZipCubit>();
  ThemeCubit get themeCubit => context.read<ThemeCubit>();

  @override
  void initState() {
    super.initState();
    _recoverCounterSearchValue();
    _recoverCounterFavoritesValue();
  }

  void _recoverCounterSearchValue() async {
    int value = await sharedServices
            .getInt(SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearch;

    setState(() {
      counterSearch = value;
    });
  }

  void _recoverCounterFavoritesValue() async {
    int value =
        await sharedServices.getInt(SharedPreferencesKeys.savedZipKey) ??
            counterFav;

    setState(() {
      counterFav = value;
    });
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.greetingsText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            CounterBarWidget(
              value: counterSearch,
              icon: CupertinoIcons.checkmark,
              text: AppStrings.successfulSearchedZipsText,
              onTap: () =>
                  analytics.logEvent(name: CounterPageEvents.searchedZipCard),
            ),
            CounterBarWidget(
              value: counterFav,
              icon: CupertinoIcons.star,
              text: AppStrings.successfulSavedZipsText,
              onTap: () =>
                  analytics.logEvent(name: CounterPageEvents.favoritedZipCard),
            ),
          ],
        ),
      ),
    );
  }
}

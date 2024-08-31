import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/features/counter_page/widgets/counter_bar_widget.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/data/shared_services.dart';

import '../../commons/analytics_events.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  static const counterPageKey = Key('counterPageKey');

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counterSearch = 0;
  int counterFav = 0;

  SharedServices get sharedServices => context.read<SharedServices>();
  FirebaseAnalytics get analytics => context.read<FirebaseAnalytics>();
  SearchZipCubit get searchZipCubit => context.read<SearchZipCubit>();

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
    return Padding(
      key: CounterPage.counterPageKey,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.greetingsText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/commons/shared_preferences_keys.dart';
import 'package:zip_search/core/features/counter_page/widgets/counter_bar_widget.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/data/shared_services.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  static const counterPageKey = Key('counterPageKey');

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counterSearch = 0;
  int counterFav = 0;

  @override
  void initState() {
    super.initState();
    _recoverCounterSearchValue();
    _recoverCounterFavoritesValue();
  }

  void _recoverCounterSearchValue() async {
    int value = await SharedServices.getInt(
            SharedPreferencesKeys.counterSearchedZipsKeys) ??
        counterSearch;

    setState(() {
      counterSearch = value;
    });
  }

  void _recoverCounterFavoritesValue() async {
    int value =
        await SharedServices.getInt(SharedPreferencesKeys.savedZipKey) ??
            counterFav;

    setState(() {
      counterFav = value;
    });
  }

  SearchZipCubit get searchZipCubit => context.read<SearchZipCubit>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: CounterPage.counterPageKey,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _greetingsWidget(),
          CounterBarWidget(
            value: counterSearch,
            icon: Icons.check,
            text: AppStrings.successfulSearchedZipsText,
          ),
          CounterBarWidget(
            value: counterFav,
            icon: Icons.bookmark_border_rounded,
            text: AppStrings.successfulSavedZipsText,
          ),
        ],
      ),
    );
  }

  Widget _greetingsWidget() => const Text(
        AppStrings.greetingsText,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      );
}

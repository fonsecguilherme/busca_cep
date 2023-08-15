import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/commons/app_strings.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  static const counterPageKey = Key('counterPageKey');

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
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
          _counterBarWidgets(
            counterType: searchZipCubit.counterSearchedZips,
            icon: Icons.check,
            text: AppStrings.successfulSearchedZipsText,
          ),
          _counterBarWidgets(
            counterType: searchZipCubit.counterFavZips,
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

  Widget _counterBarWidgets({
    required int counterType,
    required IconData icon,
    required String text,
  }) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                ),
              ),
              BlocBuilder<SearchZipCubit, SearchZipState>(
                builder: (context, state) {
                  return Text(
                    '$counterType',
                  );
                },
              ),
            ],
          ),
        ),
      );
}

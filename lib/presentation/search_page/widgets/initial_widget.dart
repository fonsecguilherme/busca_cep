import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';

import 'multiple_address_widget.dart';
import 'single_address_widget.dart';

class InitialWidget extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const InitialWidget({super.key, required this.analytics});

  static const initialWidgetKey = Key('initialWidgetKey');

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  SearchCubit get cubit => context.read<SearchCubit>();

  late List<String> states;

  @override
  void initState() {
    super.initState();
    states = cubit.getBrStates();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Column(
            key: InitialWidget.initialWidgetKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.searchPageMessage,
              ),
              const SizedBox(height: 8.0),
              SegmentedButton<SearchOptions>(
                segments: const [
                  ButtonSegment(
                    value: SearchOptions.zip,
                    label: Text(AppStrings.zipText),
                    icon: Icon(CupertinoIcons.home),
                  ),
                  ButtonSegment(
                    value: SearchOptions.address,
                    label: Text(AppStrings.addressText),
                    icon: Icon(CupertinoIcons.home),
                  ),
                ],
                selected: {state.selectedOption},
                onSelectionChanged: (Set<SearchOptions> newSelection) =>
                    cubit.toggleOption(),
              ),
              switch (state.selectedOption) {
                SearchOptions.zip => SingleAddressWidget(
                    analytics: widget.analytics,
                    cubit: cubit,
                  ),
                SearchOptions.address => MultipleAddressWidget(
                    analytics: widget.analytics,
                    cubit: cubit,
                    states: states,
                  ),
              }
            ],
          );
        },
      );
}

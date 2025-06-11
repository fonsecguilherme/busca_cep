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
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: SearchOptions.zip,
                    label: const Text(AppStrings.zipText),
                    icon: Icon(
                      Icons.location_on,
                      color: cubit.state.selectedOption == SearchOptions.zip
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  ButtonSegment(
                    value: SearchOptions.address,
                    label: const Text(AppStrings.addressText),
                    icon: Icon(
                      CupertinoIcons.home,
                      color: cubit.state.selectedOption == SearchOptions.address
                          ? Colors.black
                          : Colors.grey,
                    ),
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

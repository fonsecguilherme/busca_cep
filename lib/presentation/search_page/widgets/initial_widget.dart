import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/analytics_events.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/widgets/custom_elevated_button.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';

class InitialWidget extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const InitialWidget({super.key, required this.analytics});

  static const initialWidgetKey = Key('initialWidgetKey');

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  SearchCubit get cubit => context.read<SearchCubit>();

  late TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    _zipController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Column(
        key: InitialWidget.initialWidgetKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.searchPageMessage,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              maxLength: 8,
              controller: _zipController,
              onEditingComplete: () {
                widget.analytics.logEvent(
                  name: SearchPageEvents.searchPageButton,
                );
                cubit.searchZip(zipCode: _zipController.text);
                _zipController.clear();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 2.0,
                  ),
                ),
                filled: true,
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: AppStrings.textFieldText,
              ),
            ),
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (BuildContext context, SearchState state) {
              if (state is LoadingSearchState) {
                return const CircularProgressIndicator();
              }
              return CustomElevatedButton(
                onTap: () {
                  widget.analytics.logEvent(
                    name: SearchPageEvents.searchPageButton,
                  );
                  cubit.searchZip(zipCode: _zipController.text);
                  _zipController.clear();
                },
                icon: CupertinoIcons.search,
                title: AppStrings.searchPagebuttonText,
              );
            },
          ),
        ],
      );

  @override
  void dispose() {
    _zipController.dispose();
    super.dispose();
  }
}

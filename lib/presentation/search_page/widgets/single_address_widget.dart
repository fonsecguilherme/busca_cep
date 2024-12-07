import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';

import '../../../core/commons/analytics_events.dart';
import '../../../core/commons/app_strings.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../cubit/search_state.dart';

class SingleAddressWidget extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final SearchCubit cubit;

  const SingleAddressWidget({
    super.key,
    required this.analytics,
    required this.cubit,
  });

  @override
  State<SingleAddressWidget> createState() => _SingleAddressWidgetState();
}

class _SingleAddressWidgetState extends State<SingleAddressWidget> {
  late TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    _zipController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomTextfield(
              hintText: AppStrings.textFieldText,
              controller: _zipController,
              onEditingComplete: () {
                widget.analytics.logEvent(
                  name: SearchPageEvents.searchPageButton,
                );
                widget.cubit.searchZip(zipCode: _zipController.text);
                _zipController.clear();
              },
              maxCharacters: 8,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
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
                  widget.cubit.searchZip(zipCode: _zipController.text);
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

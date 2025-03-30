import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';

import '../../../core/commons/analytics_events.dart';
import '../../../core/commons/app_strings.dart';
import '../../../core/commons/logger_helper.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../cubit/search_state.dart';

class MultipleAddressWidget extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final SearchCubit cubit;
  final List<String> states;

  const MultipleAddressWidget({
    super.key,
    required this.cubit,
    required this.analytics,
    required this.states,
  });

  @override
  State<MultipleAddressWidget> createState() => _MultipleAddressWidgetState();
}

class _MultipleAddressWidgetState extends State<MultipleAddressWidget> {
  // TextControllers
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.states.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: 16.0,
          ),
          child: CustomTextfield(
            key: const Key('address_input_textField'),
            hintText: 'Endereço',
            controller: addressController,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            bottom: 16.0,
          ),
          child: CustomTextfield(
            key: const Key('city'),
            hintText: 'Cidade',
            controller: cityController,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return DropdownMenu<String>(
              key: const Key('state_input_textField'),
              initialSelection: widget.states.first,
              onSelected: (String? value) {
                dropdownValue = value!;
              },
              dropdownMenuEntries:
                  widget.states.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8.0),
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

                widget.cubit.searchAddress(
                  address: addressController.text,
                  city: cityController.text,
                  state: dropdownValue,
                );

                LoggerHelper.debug(
                  'Endereço: ${addressController.text},\n'
                  'cidade: ${cityController.text}\n'
                  'estado: $dropdownValue',
                );
              },
              icon: CupertinoIcons.search,
              title: AppStrings.searchPagebuttonText,
            );
          },
        ),
      ],
    );
  }
}

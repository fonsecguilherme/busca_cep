import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';

class InitialWidget extends StatefulWidget {
  const InitialWidget({super.key});

  static const initialWidgetKey = Key('initialWidgetKey');

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  SearchZipCubit get cubit => context.read<SearchZipCubit>();

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
          const Text(
            AppStrings.searchPageMessage,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              maxLength: 8,
              controller: _zipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: AppStrings.textFieldText,
                fillColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          BlocBuilder<SearchZipCubit, SearchZipState>(
            builder: (BuildContext context, SearchZipState state) {
              if (state is LoadingSearchZipState) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  cubit.searchZip(zipCode: _zipController.text);
                  _zipController.clear();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.search_rounded),
                    SizedBox(width: 5),
                    Text(AppStrings.searchPagebuttonText),
                  ],
                ),
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

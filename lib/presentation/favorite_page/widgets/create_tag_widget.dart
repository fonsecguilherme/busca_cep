import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/messages.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/core/widgets/custom_elevated_button.dart';
import 'package:zip_search/core/widgets/focus_widget.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_state.dart';

import '../../../core/commons/app_strings.dart';

class CreateTagWidget extends StatefulWidget {
  final FavoriteModel favoriteAddress;

  const CreateTagWidget({super.key, required this.favoriteAddress});

  @override
  State<CreateTagWidget> createState() => _CreateTagWidgetState();
}

class _CreateTagWidgetState extends State<CreateTagWidget> {
  final tagInputController = TextEditingController();

  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();

  @override
  Widget build(BuildContext context) =>
      BlocListener<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is AddedTagZipState) {
            Messages.of(context).showSuccess(state.message);
            Navigator.pop(context);
          } else if (state is RemovedTagZipState) {
            Messages.of(context).showSuccess(state.message);
            Navigator.pop(context);
          }
        },
        child: FocusWidget(
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.createTagPageTitleText,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextField(
                    controller: tagInputController,
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    icon: Icons.sell_outlined,
                    title: AppStrings.createTagPageButtonText,
                    onTap: () {
                      favoriteCubit.createTag(
                        favoriteAddress: widget.favoriteAddress,
                        tag: tagInputController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    tagInputController.dispose();
    super.dispose();
  }
}

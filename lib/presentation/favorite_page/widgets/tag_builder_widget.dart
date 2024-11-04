import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';

import '../../../core/commons/app_strings.dart';
import '../cubit/favorite_state.dart';
import 'create_tag_widget.dart';

class CardTagsWidget extends StatelessWidget {
  final FavoriteModel favoriteAddress;

  const CardTagsWidget({
    super.key,
    required this.favoriteAddress,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoriteCubit>();

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        switch (state) {
          case AddedTagZipState s:
            return _TagBuilderWidget(
              tagAmount: s.tags.length,
              tags: s.tags,
              favoriteCubit: favoriteCubit,
              favoriteAddress: favoriteAddress,
            );
          default:
            return _TagBuilderWidget(
              tagAmount: favoriteAddress.tags.length,
              tags: favoriteAddress.tags,
              favoriteCubit: favoriteCubit,
              favoriteAddress: favoriteAddress,
            );
        }
      },
    );
  }
}

class _TagBuilderWidget extends StatelessWidget {
  final FavoriteModel favoriteAddress;
  final FavoriteCubit favoriteCubit;
  final int tagAmount;
  final List<String> tags;

  const _TagBuilderWidget({
    required this.favoriteAddress,
    required this.favoriteCubit,
    required this.tagAmount,
    required this.tags,
  }) : super();

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 6.0,
        runSpacing: 8.0,
        children: [
          ...List.generate(
            tagAmount,
            (index) => _TagWidget(
              tagName: tags.elementAt(index),
              action: () {
                favoriteCubit.createTag(
                  favoriteAddress: favoriteAddress,
                  tag: tags.elementAt(index),
                );
              },
            ),
          ),
          Visibility(
            visible: tags.length < 5,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: favoriteCubit,
                      child: CreateTagWidget(
                        favoriteAddress: favoriteAddress,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.sell_outlined,
                size: 16,
              ),
              label: const Text(AppStrings.addTagText),
            ),
          )
        ],
      );
}

class _TagWidget extends StatelessWidget {
  final String tagName;
  final VoidCallback action;

  const _TagWidget({required this.tagName, required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        // height: 48,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: const StadiumBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.close,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 4),
              Text(
                tagName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

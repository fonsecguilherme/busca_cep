import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/model/favorite_model.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/favorite_page/widgets/create_tag_widget.dart';

import '../cubit/favorite_state.dart';

class TagBuilderWidget extends StatelessWidget {
  final FavoriteModel favoriteAddress;

  const TagBuilderWidget({
    super.key,
    required this.favoriteAddress,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoriteCubit>();

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (_, state) {
        switch (state) {
          case LoadFavoriteZipState s:
            return Wrap(
              spacing: 6.0,
              runSpacing: 8.0,
              children: [
                ...List.generate(
                  favoriteAddress.tags.length,
                  (index) => _TagWidget2(
                    tagName: favoriteAddress.tags.elementAt(index),
                    action: () {
                      favoriteCubit.createTag(
                        favoriteAddress: favoriteAddress,
                        tag: favoriteAddress.tags.elementAt(index),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: favoriteAddress.tags.length < 5,
                  child: _TagWidget2(
                    action: () {
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
                  ),
                )
              ],
            );
          default:
            return Center(child: const Text('caiu no default'));
        }
      },
    );
  }
}

class _TagWidget2 extends StatelessWidget {
  final String? tagName;
  final VoidCallback action;

  const _TagWidget2({this.tagName, required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: const StadiumBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tagName ?? 'Adicionar tag',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.sell_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

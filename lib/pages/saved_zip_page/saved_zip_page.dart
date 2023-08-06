import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/favorites/favorites_cubit.dart';
import 'package:zip_search/data/cubits/favorites/favorites_state.dart';

class SavedZipPage extends StatefulWidget {
  const SavedZipPage({super.key});

  @override
  State<SavedZipPage> createState() => _SavedZipState();
}

class _SavedZipState extends State<SavedZipPage> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return const Center(
            child: Text('text'),
          );
        },
      );
}

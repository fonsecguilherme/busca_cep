import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/messages.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/core/features/search_page/widgets/initial_widget.dart';
import 'package:zip_search/core/features/search_page/widgets/success_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _HomeState();
}

class _HomeState extends State<SearchPage> {
  SearchZipCubit get searchZipCubit => context.read<SearchZipCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<SearchZipCubit, SearchZipState>(
          bloc: searchZipCubit,
          listener: listener,
          builder: builder,
        ),
      );

  void listener(BuildContext context, SearchZipState state) {
    if (state is ErrorSearchZipState) {
      Messages.of(context).showError(state.errorMessage);
    } else if (state is ErrorEmptyZipState) {
      Messages.of(context).showError(state.errorEmptyMessage);
    } else if (state is ErrorAlreadyAddedZipState) {
      Messages.of(context).showError(state.errorMessage);
    } else if (state is FavoritedAddressZipState) {
      Messages.of(context).showSuccess(state.message);
    }
  }

  Widget builder(BuildContext context, SearchZipState state) {
    if (state is LoadingSearchZipState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is FetchedSearchZipState) {
      return SuccessWidget(
        address: state.address,
      );
    } else {
      return const InitialWidget();
    }
  }
}

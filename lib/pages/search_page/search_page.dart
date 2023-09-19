import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/pages/search_page/widgets/initial_widget.dart';
import 'package:zip_search/pages/search_page/widgets/success_widget.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(state.errorMessage),
          duration: const Duration(seconds: 5),
        ),
      );
    } else if (state is ErrorAlreadyAddedZipState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(state.errorMessage),
          duration: const Duration(seconds: 5),
        ),
      );
    } else if (state is FavoritedAddressZipState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          duration: const Duration(seconds: 5),
        ),
      );
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

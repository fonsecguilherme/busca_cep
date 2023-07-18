import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/pages/home_page/widgets/inital_widget.dart';
import 'package:zip_search/pages/home_page/widgets/success_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  SearchZipCubit get cubit => context.read<SearchZipCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Busca CEP concept'),
          centerTitle: true,
        ),
        body: BlocConsumer<SearchZipCubit, SearchZipState>(
          bloc: cubit,
          listener: listener,
          builder: builder,
        ),
      );

  void listener(BuildContext context, SearchZipState state) {
    if (state is ErrorSearchZipState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(state.errorMessage),
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
      return SuccessWidget(address: state.address);
    }
    return const InitialWidget();
  }
}

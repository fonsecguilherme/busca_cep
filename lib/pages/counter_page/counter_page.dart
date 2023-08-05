import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  SearchZipCubit get cubit => context.read<SearchZipCubit>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Quantidade de CEPS procurados com sucesso:'),
          BlocBuilder<SearchZipCubit, SearchZipState>(
            builder: (context, state) {
              return Text('${cubit.counterValue}');
            },
          ),
        ],
      ),
    );
  }
}

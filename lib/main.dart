import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/counter/counter_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/via_cep_repository.dart';
import 'package:zip_search/pages/home_page/home_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final ViaCepRepository viaCepRepository = ViaCepRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchZipCubit(
              viaCepRepository,
            ),
          ),
          BlocProvider(
            create: (context) => CounterCubit(),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}

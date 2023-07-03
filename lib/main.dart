import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/counter/counter_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/data/via_cep_repository.dart';
import 'package:zip_search/model/address_model.dart';

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
        child: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  SearchZipCubit get cubit => context.read<SearchZipCubit>();

  late TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    _zipController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buca CEP concept'),
        centerTitle: true,
      ),
      body: BlocBuilder(
        bloc: cubit,
        builder: (context, state) {
          if (state is InitialSearchZipState) {
            return initialWidget();
          } else if (state is LoadingSearchZipState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FetchedSearchZipState) {
            return addressInfo(state.address);
          } else {
            return const Text('outro estado');
          }
        },
      ),
    );
  }

  Widget addressInfo(AddressModel address) {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        initialWidget(),
        Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey,
            child: Column(
              children: [
                Text(
                  'CEP pesquisado: ${address.cep}\n${address.logradouro}\n${address.complemento}'
                  '\nBairro: ${address.bairro},\nDDD: ${address.ddd},\nCidade: ${address.localidade},\nEstado: ${address.uf}',
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ],
    ));
  }

  Widget initialWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Digite o seu cep abaixo: '),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _zipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: "Type in your text",
                fillColor: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              cubit.searchZip(zipCode: _zipController.text);
              _zipController.clear();
            },
            child: const Text('Buscar cep!'),
          )
        ],
      );

  @override
  void dispose() {
    _zipController.dispose();
    super.dispose();
  }
}

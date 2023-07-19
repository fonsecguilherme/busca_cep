import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';

class InitialWidget extends StatefulWidget {
  const InitialWidget({super.key});

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  SearchZipCubit get cubit => context.read<SearchZipCubit>();

  late TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    _zipController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Digite o seu cep abaixo: '),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              maxLength: 8,
              controller: _zipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: "Somente números =)",
                fillColor: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
              'Quantidade de ceps procuados com sucesso: ${cubit.counterValue}'),
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

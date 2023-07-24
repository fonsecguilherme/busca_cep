import 'package:flutter/material.dart';
import 'package:zip_search/model/address_model.dart';
import 'package:zip_search/pages/home_page/widgets/inital_widget.dart';

class SuccessWidget extends StatelessWidget {
  final AddressModel address;

  static const addressFoundWidgetKey = Key('addressFoundWidgetKey');

  const SuccessWidget({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const InitialWidget(),
            const SizedBox(height: 12),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 211, 211, 211),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'CEP pesquisado: ${address.cep}\n${address.logradouro}\n${address.complemento}'
                    '\nBairro: ${address.bairro},\nDDD: ${address.ddd},\nCidade: ${address.localidade},\nEstado: ${address.uf}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

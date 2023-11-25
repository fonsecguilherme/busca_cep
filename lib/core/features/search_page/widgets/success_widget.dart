import 'package:flutter/material.dart';
import 'package:zip_search/core/commons/app_strings.dart';
import 'package:zip_search/core/model/address_model.dart';
import 'package:zip_search/core/features/search_page/widgets/add_favorites_button.dart';
import 'package:zip_search/core/features/search_page/widgets/initial_widget.dart';

class SuccessWidget extends StatelessWidget {
  final AddressModel address;

  static const addressFoundWidgetKey = Key('addressFoundWidgetKey');

  const SuccessWidget({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        key: SuccessWidget.addressFoundWidgetKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const InitialWidget(),
            _addressWidget(),
            AddFavoritesButton(address: address),
          ],
        ),
      );

  Widget _addressWidget() => Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 18,
          right: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.addressText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${address.logradouro} ${_complementFormat()}'
              ' - ${address.bairro} \n${address.localidade} ${address.uf}'
              ' - CEP ${address.cep}',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      );

  String _complementFormat() =>
      address.complemento.isEmpty ? '' : '- ${address.complemento}';
}

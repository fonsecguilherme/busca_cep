import 'package:zip_search/core/model/address_model.dart';

import 'app_strings.dart';

extension AddressExtension on String {
  String complementFormat(AddressModel address) =>
      address.complemento.isEmpty ? '' : '- ${address.complemento}';

  String formatAddress(AddressModel address) =>
      '${address.logradouro} ${address.complemento.complementFormat(address)}'
      ' - ${address.bairro} \n${address.localidade} ${address.uf}'
      ' - CEP ${address.cep}';

  String favoriteCardAddressFormat(AddressModel address) =>
      '${address.logradouro},\n${_complementField(address.complemento)},'
      '\nBairro: ${address.bairro},'
      '\n${address.localidade}, ${address.uf}';

  String _complementField(String complement) {
    return complement.isEmpty ? AppStrings.emptyComplementText : complement;
  }
}

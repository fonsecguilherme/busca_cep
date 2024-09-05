import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zip_search/core/model/address_model.dart';

import '../core/exceptions/custom_exceptions.dart';

abstract interface class IViaCepRepository {
  Future<AddressModel?> fetchAddress(String zipCode);
}

class ViaCepRepository implements IViaCepRepository {
  @override
  Future<AddressModel?> fetchAddress(String zipCode) async {
    final String url = 'https://viacep.com.br/ws/$zipCode/json/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final address = jsonDecode(response.body);

      if (address['erro'] == null) {
        return AddressModel.fromJson(address);
      } else {
        throw InvalidZipException('CEP not found.');
      }
    } else if (response.statusCode == 400) {
      throw EmptyZipException('User did not type a CEP.');
    } else {
      throw Exception(
          'Error when trying to access API. Status code: ${response.statusCode}');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zip_search/model/address_model.dart';

class ViaCepRepository {
  Future<AddressModel> fetchAddress(String zipCode) async {
    final String url = 'https://viacep.com.br/ws/$zipCode/json/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final address = jsonDecode(response.body);
      return AddressModel.fromJson(address);
    } else if (response.statusCode == 400) {
      throw Exception('Bad request');
    } else if (response.statusCode == 404) {
      throw Exception('CEP inválido');
    } else {
      throw Exception('Erro desconhecido!');
    }
  }
}

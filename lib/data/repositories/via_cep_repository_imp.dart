import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zip_search/core/exceptions/error.dart';

import '../../core/model/address_model.dart';
import '../../domain/repositories/via_cep_repository.dart';

typedef ApiResponse<T> = ({T? data, Error error});

class ViaCepRepositoryImp implements IViaCepRepository {
  @override
  Future<ApiResponse<AddressModel?>> fetchAddress(String zipCode) async {
    final String url = 'https://viacep.com.br/ws/$zipCode/json/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final address = jsonDecode(response.body);

        if (address.containsKey('erro') && address['erro'] == 'true') {
          return (
            data: null,
            error: InvalidZipFailure(message: 'Failed to reach link: 404')
          );
        } else {
          final decodedAddress = AddressModel.fromJson(address);
          return (data: decodedAddress, error: Empty());
        }
      } else if (response.statusCode == 400) {
        return (
          data: null,
          error: EmptyZipFailure(message: 'User did not type any CEP')
        );
      } else {
        return (
          data: null,
          error: Failure(message: 'Failed to load data: ${response.statusCode}')
        );
      }
    } catch (e) {
      return (
        data: null,
        error: Failure(message: 'Failure to connect to API: $e')
      );
    }
  }
}

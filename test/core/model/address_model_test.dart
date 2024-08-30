import 'package:flutter_test/flutter_test.dart';
import 'package:zip_search/core/model/address_model.dart';

void main() {
  test('It should parse AddressModel correctly fromJson', () async {
    final AddressModel address = AddressModel.fromJson(_jsonAddress);

    expect(address.cep, '00000000');
    expect(address.logradouro, 'Rua do limoeiro');
    expect(address.complemento, 'Não possui');
    expect(address.bairro, 'Zezin bebin');
    expect(address.localidade, 'Cazabun');
    expect(address.uf, 'AL');
    expect(address.ddd, '82');
  });

  test('It should parse AddressModel correctly toJson', () async {
    final address = _address.toJson();

    expect(_jsonAddress.toString(), equals(address.toString()));
  });
}

const _address = AddressModel(
  cep: '00000000',
  logradouro: 'Rua do limoeiro',
  complemento: 'Não possui',
  bairro: 'Zezin bebin',
  localidade: 'Cazabun',
  uf: 'AL',
  ddd: '82',
);

const _jsonAddress = {
  'cep': '00000000',
  'logradouro': 'Rua do limoeiro',
  'complemento': 'Não possui',
  'bairro': 'Zezin bebin',
  'localidade': 'Cazabun',
  'uf': 'AL',
  'ddd': '82',
};

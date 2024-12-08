import 'package:zip_search/core/model/address_model.dart';

abstract interface class IViaCepRepository {
  Future<AddressModel?> fetchAddress(String zipCode);
  Future<List<AddressModel>?> fetchAddressList({
    required String address,
    required String state,
    required String city,
  });
}

import 'package:zip_search/core/model/address_model.dart';

abstract interface class IViaCepRepository {
  Future<AddressModel?> fetchAddress(String zipCode);
}

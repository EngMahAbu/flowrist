import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/default_address_response_model.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/set_default_address_response_model.dart';

abstract interface class SetDefaultAddressDataSource {
  Future<BaseResponse<DefaultAddressResponseModel>> setDefaultAddress(
    String addressId,
  );
}

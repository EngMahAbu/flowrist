import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/data_sources/contract/remote/checkout_remote_data_source.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_response_model.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/checkout_session_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/create_checkout_entity.dart';
import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CheckoutRepository)
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource _remoteDataSource;

  CheckoutRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<CheckoutSessionEntity>> createCheckout(
    CreateCheckoutEntity checkout,
  ) async {
    final request = CreateCheckoutRequestModel.fromEntity(checkout);
    final response = await _remoteDataSource.createCheckout(request);

    switch (response) {
      case SuccessResponse<CreateCheckoutResponseModel>():
        final entity = response.data?.toEntity();
        if (entity == null) {
          return ErrorResponse('Invalid checkout response');
        }

        return SuccessResponse(entity);
      case ErrorResponse<CreateCheckoutResponseModel>():
        return ErrorResponse(response.errorMessage);
    }

 
  }
}

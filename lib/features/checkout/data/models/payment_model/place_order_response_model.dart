import 'package:flowrist/features/checkout/domain/entities/payment_entity/place_order_resonse_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_order_response_model.g.dart';

@JsonSerializable()
class PlaceOrderResponseModel {
  final bool status;
  final int code;
  final String message;
  final dynamic data;
  final dynamic pagination;
  final dynamic errors;

  const PlaceOrderResponseModel({
    required this.status,
    required this.code,
    required this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory PlaceOrderResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PlaceOrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PlaceOrderResponseModelToJson(this);

  PlaceOrderResponseEntity toEntity() {
    return PlaceOrderResponseEntity(
      status: status,
      code: code,
      message: message,
    );
  }
}
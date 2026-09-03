import 'package:equatable/equatable.dart';

class PlaceOrderResponseEntity extends Equatable {
  final bool status;
  final int code;
  final String message;

  const PlaceOrderResponseEntity({
    required this.status,
    required this.code,
    required this.message,
  });

  @override
  List<Object?> get props => [
        status,
        code,
        message,
      ];
}
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verifyOtp_response_dto.g.dart';

@JsonSerializable()
class VerifyOtpResponseDto {
  final String? message;

  const VerifyOtpResponseDto({
    this.message,
  });

  factory VerifyOtpResponseDto.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$VerifyOtpResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VerifyOtpResponseDtoToJson(this);
}
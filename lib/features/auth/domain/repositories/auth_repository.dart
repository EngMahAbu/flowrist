import 'package:flowrist/config/base_response/base_response.dart';

import '../entities/user_entity.dart';


abstract interface class AuthRepository {
  Future<BaseResponse<void>> forgotPassword({
    required String email,
  });

  Future<BaseResponse<void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<BaseResponse<void>> resetPassword({
    required String email,
    required String newPassword,
  });
}
import 'package:flowrist/config/base_response/base_response.dart';

import '../../api_error_handler/api_error_handler.dart';

Future<BaseResponse<T>> safeCall<T>(
  Future<BaseResponse<T>> Function() apiCall,
) async {
  try {
    return await apiCall();
  } on Exception catch (e) {
    return ApiErrorHandler.handleException<T>(e);
  }
}

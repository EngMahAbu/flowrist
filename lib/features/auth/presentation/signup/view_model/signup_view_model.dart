import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/auth/domain/use_cases/register_use_case.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_event.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpViewModel extends Cubit<SignUpState> {
  final RegisterUseCase _registerUseCase;

  SignUpViewModel(this._registerUseCase)
    : super(BaseState(isLoading: false, errorMessage: null, data: null));

  void doIntent(SignUpEvent event) {
    switch (event) {
      case SignUpSubmittedEvent():
        _handleSignUpSubmitted(event);
    }
  }

  Future<void> _handleSignUpSubmitted(SignUpSubmittedEvent event) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _registerUseCase(event.request);

    switch (result) {
      case SuccessResponse(:final data):
        emit(state.copyWith(isLoading: false, data: data));
      case ErrorResponse(:final errorMessage):
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
    }
  }
}

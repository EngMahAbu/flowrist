import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';

class LoginState {
  final BaseState<LoginEntity> login;
  final bool rememberMe;
  final bool isFormValid;

  const LoginState({
    required this.login,
    required this.rememberMe,
    required this.isFormValid,
  });

  LoginState.initial()
    : this(login: BaseState.initial(), rememberMe: false, isFormValid: false);

  LoginState copyWith({
    BaseState<LoginEntity>? login,
    bool? rememberMe,
    bool? isFormValid,
  }) {
    return LoginState(
      login: login ?? this.login,
      rememberMe: rememberMe ?? this.rememberMe,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}

import 'package:equatable/equatable.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  final bool isPasswordVisible;
  const LoginInitial({required this.isPasswordVisible});
  @override
  List<Object?> get props => [isPasswordVisible];
}

final class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginSuccessState extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginFailedState extends LoginState {
  final String message;
  @override
  List<Object?> get props => [message];
  const LoginFailedState(this.message);
}

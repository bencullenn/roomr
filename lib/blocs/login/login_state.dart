part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class AwaitingLogin extends LoginState {
  @override
  String toString() => 'Awaiting Login { no variables }';
}

class LoginSuccess extends LoginState {
  @override
  String toString() => 'Login Success { no variables }';
}

class LoginError extends LoginState {
  final String errorMessage;

   LoginError([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => 'Login Error { errorMessage: $errorMessage }';
}

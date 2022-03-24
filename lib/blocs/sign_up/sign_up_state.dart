part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class AwaitingSignUp extends SignUpState {}

class SignUpInProgress extends SignUpState{}

class SignUpSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String errorMessage;

   SignUpError([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];
}
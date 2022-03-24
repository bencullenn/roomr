part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LogInEmail extends LoginEvent{
  final String email;
  final String password;

  LogInEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LogInEmail { Email: $email }';
}

class LogOut extends LoginEvent{}

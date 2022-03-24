part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsEvent {}

class AuthStatusChanged extends AppSettingsEvent{
  final User? user;

  AuthStatusChanged(this.user);

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'AuthStatusChanged { User: $user }';
}

class AuthLogoutRequested extends AppSettingsEvent{}
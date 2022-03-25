part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsState {}

class AppSettingsInitial extends AppSettingsState {}

class UnknownAuthStatus extends AppSettingsState {}

class Authenticated extends AppSettingsState {
  final Account? currentAccount;
  final User? currentUser;

  Authenticated([this.currentAccount, this.currentUser]);

  @override
  List<Object?> get props => [currentAccount, currentUser];
}

class Unauthenticated extends AppSettingsState {}

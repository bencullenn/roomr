part of 'account_edit_bloc.dart';

@immutable
abstract class AccountEditState {}

class LoadingAccount extends AccountEditState {}

class AccountLoaded extends AccountEditState {
  final Account account;

  AccountLoaded(this.account);

  @override
  List<Object?> get props => [account];
}

class AccountLoadError extends AccountEditState {}

class AccountUpdateInProgress extends AccountEditState {}

class AccountUpdateSuccess extends AccountEditState {
  final Account account;

  AccountUpdateSuccess(this.account);

  @override
  List<Object?> get props => [account];
}

class AccountUpdateError extends AccountEditState {
  final String errorMessage;

  AccountUpdateError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

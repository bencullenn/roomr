part of 'account_edit_bloc.dart';

@immutable
abstract class AccountEditEvent {}

class UpdateAccount extends AccountEditEvent{
  final String email;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String prefContactMethod;


  UpdateAccount({required this.email, required this.firstName, required this.lastName,
    required this.mobileNumber, required this.prefContactMethod});

  @override
  List<Object?> get props => [email,firstName, lastName, mobileNumber, prefContactMethod];

  @override
  String toString() => 'UploadListing { email: $email, firstName: $firstName, lastName: $lastName,'
      'mobileNumber: $mobileNumber, prefContactMethod: $prefContactMethod}';
}

class GetAccountForID extends AccountEditEvent{
  final String userID;

  GetAccountForID({required this.userID});

  @override
  List<Object?> get props => [userID];

  @override
  String toString() => 'GetAccountForID { accountID: $userID}';
}

class GetAccountForCurrentUser extends AccountEditEvent{}

class ShowLoadError extends AccountEditEvent {
  final String message;

  ShowLoadError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ShowLoadError { message: $message}';
}
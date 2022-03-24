part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}
class SignUpEmail extends SignUpEvent{
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String prefContactMethod;
  final String referMethod;
  final String otherReferMethodDescription;

   SignUpEmail(this.email, this.password, this.firstName, this.lastName,
      this.mobileNumber, this.prefContactMethod, this.referMethod, this.otherReferMethodDescription);

  @override
  List<Object> get props => [email, password, firstName, lastName, mobileNumber, prefContactMethod];

  @override
  String toString() => 'SignUpEmail { Email: $email }';
}

class SignOut extends SignUpEvent{}
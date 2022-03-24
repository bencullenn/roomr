import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  Account(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.uuid,
      required this.mobileNumber,
      required this.prefContactMethod,
      required this.referMethod,
      required this.otherReferMethodDescription});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  String firstName;
  String lastName;
  String email;
  String uuid;
  String mobileNumber;
  String prefContactMethod;
  String referMethod;
  String otherReferMethodDescription;

  @override
  String toString() {
    return 'Account{firstName: $firstName, lastName: $lastName, email: $email, uuid: $uuid, mobileNumber: $mobileNumber, prefContactMethod: $prefContactMethod, referMethod: $referMethod, otherReferMethodDescription: $otherReferMethodDescription}';
  }
}

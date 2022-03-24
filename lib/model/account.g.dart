// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      uuid: json['uuid'] as String,
      mobileNumber: json['mobileNumber'] as String,
      prefContactMethod: json['prefContactMethod'] as String,
      referMethod: json['referMethod'] as String,
      otherReferMethodDescription:
          json['otherReferMethodDescription'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'uuid': instance.uuid,
      'mobileNumber': instance.mobileNumber,
      'prefContactMethod': instance.prefContactMethod,
      'referMethod': instance.referMethod,
      'otherReferMethodDescription': instance.otherReferMethodDescription,
    };

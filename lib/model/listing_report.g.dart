// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingReport _$ListingReportFromJson(Map<String, dynamic> json) =>
    ListingReport(
      listingID: json['listingID'] as String,
      reportingUserID: json['reportingUserID'] as String,
      listingUserID: json['listingUserID'] as String,
      reportReason: json['reportReason'] as String,
    );

Map<String, dynamic> _$ListingReportToJson(ListingReport instance) =>
    <String, dynamic>{
      'listingID': instance.listingID,
      'reportingUserID': instance.reportingUserID,
      'listingUserID': instance.listingUserID,
      'reportReason': instance.reportReason,
    };

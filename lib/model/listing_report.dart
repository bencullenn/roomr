import 'package:json_annotation/json_annotation.dart';

part 'listing_report.g.dart';

@JsonSerializable()
class ListingReport {
  ListingReport(
      {required this.listingID,
      required this.reportingUserID,
      required this.listingUserID,
      required this.reportReason});

  factory ListingReport.fromJson( Map<String, dynamic> json ) => _$ListingReportFromJson(json);

  Map<String, dynamic> toJson() => _$ListingReportToJson(this);

  final String listingID;
  final String reportingUserID;
  final String listingUserID;
  final String reportReason;

  @override
  String toString() {
    return 'ListingReport{listingID: $listingID, reportingUserID: $reportingUserID, listingUserID: $listingUserID, reportReason: $reportReason}';
  }
}

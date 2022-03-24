import 'dart:core';
import 'package:roomr/model/listing.dart';

class ListingDetailSettings{
  ListingDetailSettings({
    required this.editable,
    required this.listingData,
    required this.listingId,
    required this.popUntilScreen
  });

  final bool editable;
  final Listing listingData;
  final String listingId;
  final String popUntilScreen;

  @override
  String toString() => 'PostDetailSettings { editable: $editable, '
      'listingData: $listingData, listingId: $listingId, popUntilScreen: $popUntilScreen}';
}
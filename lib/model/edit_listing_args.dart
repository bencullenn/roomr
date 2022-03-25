import 'package:roomr/model/listing.dart';

class EditListingArguments {
  final String listingId;
  final Listing listingData;
  final String popUntilScreen;

  EditListingArguments(this.listingId, this.listingData, this.popUntilScreen);

  @override
  String toString() {
    return 'EditListingArguments{listingId: $listingId, listingData: $listingData, popUntilScreen: $popUntilScreen}';
  }
}

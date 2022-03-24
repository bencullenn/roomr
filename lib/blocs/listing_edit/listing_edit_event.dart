part of 'listing_edit_bloc.dart';

@immutable
abstract class ListingEditEvent {}

class SearchAddressesEditing extends ListingEditEvent {
  final String query;

  SearchAddressesEditing(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchAddressesEditing { Query: $query }';
}

class AddressSelectedEditing extends ListingEditEvent {
  final String placeId;

  AddressSelectedEditing(this.placeId);

  @override
  List<Object> get props => [placeId];

  @override
  String toString() => 'AddressSelectedEditing { Place ID: $placeId }';
}

class UpdateListing extends ListingEditEvent {
  final List<XFile>? imageFileList;
  final Place? address;
  final String? incentive;
  final String? roomType;
  final String? description;
  final String? parkingType;
  final String? contractType;
  final String? rent;
  final String? utilities;
  final String? bedroomCount;
  final String? bathroomCount;
  final bool? petsAllowed;
  final bool? hasGym;
  final bool? hasPool;
  final bool? hasHotTub;
  final bool? hasAC;
  final bool? byuIdahoApproved;
  final bool? byuHawaiiApproved;
  final bool? byuProvoApproved;
  final String? ownerUid;
  final String? listingId;
  final String? listingStatus;
  final List<String>? oldPhotoLinks;
  final List<XFile>? newMobilePhotoFiles;
  final bool changePhotos;
  final bool? hasWifi;
  final bool? hasDishwasher;
  final String? laundryType;
  final bool? isFurnished;
  final bool? instantNotify;

  UpdateListing(
      {this.imageFileList,
        this.address,
        this.incentive,
        this.roomType,
        this.description,
        this.parkingType,
        this.contractType,
        this.rent,
        this.utilities,
        this.bedroomCount,
        this.bathroomCount,
        this.petsAllowed,
        this.hasGym,
        this.hasPool,
        this.hasHotTub,
        this.hasAC,
        this.byuIdahoApproved,
        this.byuHawaiiApproved,
        this.byuProvoApproved,
        this.ownerUid,
        this.isFurnished,
        this.hasDishwasher,
        this.hasWifi,
        this.laundryType,
        this.instantNotify,
        required this.listingId,
        required this.listingStatus,
        required this.oldPhotoLinks,
        required this.newMobilePhotoFiles,
        required this.changePhotos});

  @override
  List<Object?> get props => [
    imageFileList,
    address,
    incentive,
    roomType,
    description,
    parkingType,
    contractType,
    rent,
    utilities,
    bedroomCount,
    bathroomCount,
    petsAllowed,
    hasGym,
    hasPool,
    hasHotTub,
    hasAC,
    byuIdahoApproved,
    byuHawaiiApproved,
    byuProvoApproved,
    ownerUid,
    listingId,
    listingStatus,
    oldPhotoLinks,
    newMobilePhotoFiles,
    changePhotos,
    isFurnished,
    hasWifi,
    hasDishwasher,
    laundryType
  ];
}

class AuthorizeUserListingEditing extends ListingEditEvent {}

class DeleteListing extends ListingEditEvent {
  final String listingID;
  final List<String> imageLinks;

  DeleteListing(this.listingID, this.imageLinks);

  @override
  List<Object> get props => [listingID, imageLinks];

  @override
  String toString() =>
      'DeleteListing { Listing ID: $listingID, Image Links: $imageLinks }';
}

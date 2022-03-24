part of 'listing_compose_bloc.dart';

@immutable
abstract class ListingComposeEvent {}

class SearchAddresses extends ListingComposeEvent {
  final String query;

  SearchAddresses(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchAddresses { Query: $query }';
}

class AddressSelected extends ListingComposeEvent {
  final String placeId;

  AddressSelected(this.placeId);

  @override
  List<Object> get props => [placeId];

  @override
  String toString() => 'AddressSelected { Place ID: $placeId }';
}

class UploadListing extends ListingComposeEvent {
  final List<XFile>? imageMobileFileList;
  final Place? address;
  final String? incentive;
  final String? roomType;
  final String? description;
  final Timestamp? dateAvailable;
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
  final String? laundryType;
  final bool? hasAC;
  final bool? byuIdahoApproved;
  final bool? byuHawaiiApproved;
  final bool? byuProvoApproved;
  final String? ownerUid;
  final bool? instantNotify;
  final bool? hasWifi;
  final bool? isFurnished;
  final bool? hasDishwasher;

  UploadListing(
      {this.imageMobileFileList,
      this.address,
      this.incentive,
      this.roomType,
      this.description,
      this.dateAvailable,
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
      this.hasWifi,
      this.hasAC,
      this.byuIdahoApproved,
      this.byuHawaiiApproved,
      this.byuProvoApproved,
      this.ownerUid,
      this.instantNotify,
      this.isFurnished,
      this.hasDishwasher,
      this.laundryType});

  @override
  List<Object?> get props => [
        imageMobileFileList,
        address,
        incentive,
        roomType,
        description,
        dateAvailable,
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
        instantNotify,
        hasWifi,
        hasDishwasher,
        isFurnished,
        laundryType
      ];

  @override
  String toString() {
    return 'UploadListing{imageMobileFileList: $imageMobileFileList, address: $address, incentive: $incentive, roomType: $roomType, description: $description, dateAvailable: $dateAvailable, parkingType: $parkingType, contractType: $contractType, rent: $rent, utilities: $utilities, bedroomCount: $bedroomCount, bathroomCount: $bathroomCount, petsAllowed: $petsAllowed, hasGym: $hasGym, hasPool: $hasPool, hasHotTub: $hasHotTub, laundryType: $laundryType, hasAC: $hasAC, byuIdahoApproved: $byuIdahoApproved, byuHawaiiApproved: $byuHawaiiApproved, byuProvoApproved: $byuProvoApproved, ownerUid: $ownerUid, instantNotify: $instantNotify, hasWifi: $hasWifi, isFurnished: $isFurnished, hasDishwasher: $hasDishwasher}';
  }
}

class AuthorizeUserListing extends ListingComposeEvent {}

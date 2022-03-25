import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable()
class Listing {
  Listing(
      {required this.photos,
      required this.formattedAddress,
      required this.street,
      required this.city,
      required this.state,
      required this.zipCode,
      required this.incentive,
      required this.roomType,
      required this.description,
      required this.dateAvailable,
      required this.parkingType,
      required this.contractType,
      required this.rent,
      required this.utilities,
      required this.bedroomCount,
      required this.bathroomCount,
      required this.petsAllowed,
      required this.hasGym,
      required this.hasPool,
      required this.hasHotTub,
      required this.hasDishwasher,
      required this.byuIApproved,
      required this.byuHApproved,
      required this.byuPApproved,
      required this.hasAC,
      required this.isPremiumListing,
      required this.createdDate,
      required this.dateLastModified,
      required this.ownerUid,
      required this.attachedPosts,
      required this.status,
      required this.instantNotify,
      required this.laundryType,
      required this.hasWifi,
      required this.isFurnished});

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);

  final List<dynamic> photos;
  final String formattedAddress;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String incentive;
  final String roomType;
  final String description;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp dateAvailable;
  final String parkingType;
  final String contractType;
  final String laundryType;
  final bool hasWifi;
  final bool isFurnished;
  final int rent;
  final int utilities;
  final int bedroomCount;
  final int bathroomCount;
  final bool petsAllowed;
  final bool hasGym;
  final bool hasPool;
  final bool hasHotTub;
  final bool byuIApproved;
  final bool byuHApproved;
  final bool byuPApproved;
  final bool hasDishwasher;
  final bool hasAC;
  final bool isPremiumListing;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp createdDate;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final Timestamp dateLastModified;
  final String ownerUid;
  final List<String> attachedPosts;
  final String status;
  final bool instantNotify;

  static Timestamp _fromJson(int int) =>
      Timestamp.fromMillisecondsSinceEpoch(int);

  static int _toJson(Timestamp time) => time.millisecondsSinceEpoch;

  @override
  String toString() {
    return 'Listing{photos: $photos, formattedAddress: $formattedAddress, street: $street, city: $city, state: $state, zipCode: $zipCode, incentive: $incentive, roomType: $roomType, description: $description, dateAvailable: $dateAvailable, parkingType: $parkingType, contractType: $contractType, laundryType: $laundryType, hasWifi: $hasWifi, isFurnished: $isFurnished, rent: $rent, utilities: $utilities, bedroomCount: $bedroomCount, bathroomCount: $bathroomCount, petsAllowed: $petsAllowed, hasGym: $hasGym, hasPool: $hasPool, hasHotTub: $hasHotTub, byuIApproved: $byuIApproved, byuHApproved: $byuHApproved, byuPApproved: $byuPApproved, hasDishwasher: $hasDishwasher, hasAC: $hasAC, isPremiumListing: $isPremiumListing, createdDate: $createdDate, dateLastModified: $dateLastModified, ownerUid: $ownerUid, attachedPosts: $attachedPosts, status: $status, instantNotify: $instantNotify}';
  }
}

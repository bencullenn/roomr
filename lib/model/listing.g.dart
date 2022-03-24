// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      photos: json['photos'] as List<dynamic>,
      formattedAddress: json['formattedAddress'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      incentive: json['incentive'] as String,
      roomType: json['roomType'] as String,
      description: json['description'] as String,
      dateAvailable: Listing._fromJson(json['dateAvailable'] as int),
      parkingType: json['parkingType'] as String,
      contractType: json['contractType'] as String,
      rent: json['rent'] as int,
      utilities: json['utilities'] as int,
      bedroomCount: json['bedroomCount'] as int,
      bathroomCount: json['bathroomCount'] as int,
      petsAllowed: json['petsAllowed'] as bool,
      hasGym: json['hasGym'] as bool,
      hasPool: json['hasPool'] as bool,
      hasHotTub: json['hasHotTub'] as bool,
      hasDishwasher: json['hasDishwasher'] as bool,
      byuIApproved: json['byuIApproved'] as bool,
      byuHApproved: json['byuHApproved'] as bool,
      byuPApproved: json['byuPApproved'] as bool,
      hasAC: json['hasAC'] as bool,
      isPremiumListing: json['isPremiumListing'] as bool,
      createdDate: Listing._fromJson(json['createdDate'] as int),
      dateLastModified: Listing._fromJson(json['dateLastModified'] as int),
      ownerUid: json['ownerUid'] as String,
      attachedPosts: (json['attachedPosts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      instantNotify: json['instantNotify'] as bool,
      laundryType: json['laundryType'] as String,
      hasWifi: json['hasWifi'] as bool,
      isFurnished: json['isFurnished'] as bool,
);

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'photos': instance.photos,
      'formattedAddress': instance.formattedAddress,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'incentive': instance.incentive,
      'roomType': instance.roomType,
      'description': instance.description,
      'dateAvailable': Listing._toJson(instance.dateAvailable),
      'parkingType': instance.parkingType,
      'contractType': instance.contractType,
      'laundryType': instance.laundryType,
      'hasWifi': instance.hasWifi,
      'isFurnished': instance.isFurnished,
      'rent': instance.rent,
      'utilities': instance.utilities,
      'bedroomCount': instance.bedroomCount,
      'bathroomCount': instance.bathroomCount,
      'petsAllowed': instance.petsAllowed,
      'hasGym': instance.hasGym,
      'hasPool': instance.hasPool,
      'hasHotTub': instance.hasHotTub,
      'byuIApproved': instance.byuIApproved,
      'byuHApproved': instance.byuHApproved,
      'byuPApproved': instance.byuPApproved,
      'hasDishwasher': instance.hasDishwasher,
      'hasAC': instance.hasAC,
      'isPremiumListing': instance.isPremiumListing,
      'createdDate': Listing._toJson(instance.createdDate),
      'dateLastModified': Listing._toJson(instance.dateLastModified),
      'ownerUid': instance.ownerUid,
      'attachedPosts': instance.attachedPosts,
      'status': instance.status,
      'instantNotify': instance.instantNotify,
};

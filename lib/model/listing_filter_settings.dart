import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingFilterSettings {
  ListingFilterSettings(
      {this.minPrice,
      this.maxPrice,
      this.hasAirConditioning,
      this.petsAllowed,
      this.hasWifi,
      this.hasDishwasher,
      this.isFurnished,
      this.laundryType,
      this.hasPool,
      this.hasHotTub,
      this.hasGym,
      this.roomType,
      this.contractType,
      this.parkingType,
      this.startAvailabilityDate,
      this.endAvailabilityDate,
      this.bedroomAmount,
      this.bathroomAmount,
      this.anyDate}) {
    if (hasAirConditioning == false &&
        petsAllowed == false &&
        hasDishwasher == false &&
        isFurnished == false &&
        hasWifi == false &&
        hasPool == false &&
        hasHotTub == false &&
        hasGym == false) {
      this.amenitiesFiltersDisabled = true;
    } else {
      this.amenitiesFiltersDisabled = false;
    }
  }

  late bool amenitiesFiltersDisabled;
  final int? minPrice;
  final int? maxPrice;
  final bool? hasAirConditioning;
  final bool? hasDishwasher;
  final bool? petsAllowed;
  final bool? isFurnished;
  final bool? hasWifi;
  final bool? hasPool;
  final bool? hasHotTub;
  final bool? hasGym;
  final String? roomType;
  final String? contractType;
  final String? laundryType;
  final String? parkingType;
  final Timestamp? startAvailabilityDate;
  final Timestamp? endAvailabilityDate;
  final int? bedroomAmount;
  final int? bathroomAmount;
  final bool? anyDate;

  @override
  String toString() =>
      'ListingFilterSettings { Amenities filters disabled: $amenitiesFiltersDisabled, Min Price: $minPrice, '
      'Max Price: $maxPrice, Has AC: $hasAirConditioning, Pets allowed: $petsAllowed, Has Wifi: $hasWifi,  Had Dishwasher: $hasDishwasher,  '
      'Has Pool: $hasPool, Has Hot Tub: $hasHotTub, Has Gym: $hasGym, Room Type: $roomType, Contract Type: $contractType, is Furnished: $isFurnished, '
      'Parking Type: $parkingType, Start Availability Date: $startAvailabilityDate, End Availability Date: $endAvailabilityDate,'
      ' Bedroom Amount: $bedroomAmount, Bathroom Amount: $bathroomAmount }';
}

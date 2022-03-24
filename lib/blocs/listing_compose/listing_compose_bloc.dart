import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/model/place_search.dart';
import 'package:roomr/services/data_service.dart';
import 'package:roomr/services/places_service.dart';
import 'package:get/get.dart';

part 'listing_compose_event.dart';

part 'listing_compose_state.dart';

class ListingComposeBloc
    extends Bloc<ListingComposeEvent, ListingComposeState> {
  late final PlacesService placesService;

  //late final LocationService locationService;
  late final DataService dataService;

  ListingComposeBloc() : super(ListingComposeInitial()) {
    this.placesService = Get.find();
    this.dataService = Get.find();

    on<SearchAddresses>((event, emit) async {
      emit(AddressLoadInProgress());
      if (event.query == '') {
        emit(ListingComposeInitial());
      } else {
        emit(AddressLoadSuccess(
            await placesService.getAddressAutocomplete(event.query)));
      }
    });

    on<AddressSelected>((event, emit) async {
      emit(AddressLoadInProgress());
      Place? place = await placesService.getPlace(event.placeId);
      emit(AddressUpdated(place));
    });

    on<AuthorizeUserListing>((event, emit) async {
      emit(AuthenticatingUser());
    });

    on<UploadListing>((event, emit) async {
      emit(ListingUploadInProgress());
      String result = await dataService.uploadListing(
          imageMobileFileList: event.imageMobileFileList,
          place: event.address,
          incentive: event.incentive,
          roomType: event.roomType,
          description: event.description,
          dateAvailable: event.dateAvailable,
          parkingType: event.parkingType,
          contractType: event.contractType,
          rent: event.rent,
          utilities: event.utilities,
          bedroomCount: event.bedroomCount,
          bathroomCount: event.bathroomCount,
          petsAllowed: event.petsAllowed,
          hasGym: event.hasGym,
          hasPool: event.hasPool,
          hasHotTub: event.hasHotTub,
          laundryType: event.laundryType,
          hasAC: event.hasAC,
          byuIdahoApproved: false,
          byuHawaiiApproved: false,
          byuProvoApproved: false,
          ownerUid: event.ownerUid,
          instantNotify: event.instantNotify,
          hasWifi: event.hasWifi,
          hasDishwasher: event.hasDishwasher,
          isFurnished: event.isFurnished);
      if (result == 'success') {
        emit(ListingUploadSuccess());
      } else {
        emit(ListingUploadError(result));
      }
    });
  }
}


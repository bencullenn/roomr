import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/model/place_search.dart';
import 'package:roomr/services/data_service.dart';
import 'package:roomr/services/places_service.dart';

part 'listing_edit_event.dart';
part 'listing_edit_state.dart';

class ListingEditBloc extends Bloc<ListingEditEvent, ListingEditState> {
  late final PlacesService placesService;

  //late final LocationService locationService;
  late final DataService dataService;

  ListingEditBloc() : super(ListingEditInitial()) {
    this.placesService = Get.find();
    //this.locationService = getIt<LocationService>();
    this.dataService = Get.find();

    on<SearchAddressesEditing>((event, emit) async {
      emit(AddressLoadInProgressEditing());
      if (event.query == '') {
        emit(ListingEditInitial());
      } else {
        emit(AddressLoadSuccessEditing(
            await placesService.getCityAutocomplete(event.query)));
      }
    });

    on<AddressSelectedEditing>((event, emit) async {
      emit(AddressLoadInProgressEditing());
      Place? place = await placesService.getPlace(event.placeId);
      emit(AddressUpdatedEditing(place));
    });

    on<AuthorizeUserListingEditing>((event, emit) async {
      emit(AuthenticatingUserEditListing());
    });

    on<UpdateListing>((event, emit) async {
      emit(ListingUpdateInProgress());
      String result = await dataService.updateListing(
          place: event.address,
          incentive: event.incentive,
          roomType: event.roomType,
          description: event.description,
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
          listingId: event.listingId,
          listingStatus: event.listingStatus,
          oldPhotoLinks: event.oldPhotoLinks,
          newMobilePhotoFiles: event.newMobilePhotoFiles,
          changePhotos: event.changePhotos,
          hasWifi: event.hasWifi,
          hasDishwasher: event.hasDishwasher,
          instantNotify: event.instantNotify,
          isFurnished: event.isFurnished);
      if (result == 'success') {
        emit(ListingUpdateSuccess());
      } else {
        emit(ListingUpdateError(result));
      }
    });

    on<DeleteListing>((event, emit) async {
      emit(ListingDeleteInProgress());
      String result = await dataService.deleteListingWithID(
          event.listingID, event.imageLinks);
      if (result == "success") {
        emit(ListingDeleteSuccess());
      } else {
        emit(ListingDeleteError(result));
      }
    });
  }
}

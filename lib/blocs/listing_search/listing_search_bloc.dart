import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/listing_filter_settings.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/model/place_search.dart';
import 'package:roomr/services/data_service.dart';
import 'package:roomr/services/places_service.dart';

part 'listing_search_event.dart';

part 'listing_search_state.dart';

class ListingSearchBloc extends Bloc<ListingSearchEvent, ListingSearchState> {
  late final PlacesService placesService;
  late final DataService dataService;

  ListingSearchBloc() : super(AwaitingSearch()) {
    this.placesService = Get.find();
    this.dataService = Get.find();

    on<LoadListingsWithFilters>((event, emit) async {
      emit(ListingLoadInProgress());
      emit(ListingLoadSuccess(await dataService.getListings(
          filters: event.filters, location: event.location)));
    });

    on<LocationSelected>((event, emit) async {
      Place? place = await placesService.getPlace(event.placeId);
      emit(SettingListingSearchLocation(place));
    });

    on<SearchPlaces>((event, emit) async {
      emit(PlacesLoadInProgress());
      if (event.query == '') {
        emit(SettingListingSearchLocation(null));
        emit(ListingLoadSuccess(await dataService.getListings()));
      } else {
        emit(PlacesLoadSuccess(
            await placesService.getCityAutocomplete(event.query)));
      }
    });
  }
}

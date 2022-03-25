import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/services/data_service.dart';

part 'home_feed_event.dart';

part 'home_feed_state.dart';

class HomeFeedBloc extends Bloc<HomeFeedEvent, HomeFeedState> {
  late final DataService dataService;

  HomeFeedBloc() : super(FeaturedListingLoadInProgress()) {
    this.dataService = Get.find();

    on<LoadFeaturedListings>((event, emit) async {
      print("Loading Featured Listings");
      emit(FeaturedListingLoadInProgress());
      print("Getting featured listings");
      emit(FeaturedListingLoadSuccess(await dataService.getFeaturedListings()));
      print("Featured listings returned");
    });
  }
}

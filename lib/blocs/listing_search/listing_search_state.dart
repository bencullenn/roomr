part of 'listing_search_bloc.dart';

@immutable
abstract class ListingSearchState {}

class AwaitingSearch extends ListingSearchState {}

class ListingLoadInProgress extends ListingSearchState {}

class ListingLoadError extends ListingSearchState {
  final String errorMessage;

  ListingLoadError([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];
}

class ListingLoadSuccess extends ListingSearchState {
  final List<QueryDocumentSnapshot<Listing>> listings;

  ListingLoadSuccess(this.listings);

  @override
  List<Object?> get props => [listings];
}

class PlacesLoadInProgress extends ListingSearchState {}

class PlacesLoadError extends ListingSearchState {
  final String errorMessage;

  PlacesLoadError([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];
}

class PlacesLoadSuccess extends ListingSearchState {
  final List<PlaceSearch>? places;

  PlacesLoadSuccess(this.places);

  @override
  List<Object?> get props => [places];
}

class SettingListingSearchLocation extends ListingSearchState {
  final Place? location;

  SettingListingSearchLocation(this.location);

  @override
  List<Object?> get props => [location];
}

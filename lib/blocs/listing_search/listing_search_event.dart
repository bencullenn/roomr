part of 'listing_search_bloc.dart';

@immutable
abstract class ListingSearchEvent {}

class LoadListingsWithFilters extends ListingSearchEvent {
  final ListingFilterSettings? filters;
  final Place? location;

  LoadListingsWithFilters(this.filters, this.location);

  @override
  List<Object?> get props => [filters, location];

  @override
  String toString() =>
      'LoadListingsWithFilters { Filters: $filters, Location: $location }';
}

class LocationSelected extends ListingSearchEvent {
  final String placeId;

  LocationSelected(this.placeId);

  @override
  List<Object> get props => [placeId];

  @override
  String toString() => 'LocationSelected { Place ID: $placeId }';
}

class SearchPlaces extends ListingSearchEvent {
  final String query;

  SearchPlaces(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchPlaces { Query: $query }';
}

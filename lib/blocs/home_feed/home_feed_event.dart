part of 'home_feed_bloc.dart';

@immutable
abstract class HomeFeedEvent {}

class LoadFeaturedListings extends HomeFeedEvent {}

class ShowFeaturedListings extends HomeFeedEvent {}

class SearchHomeLocations extends HomeFeedEvent {}

class HomeLocationSelected extends HomeFeedEvent {
  final String placeId;

  HomeLocationSelected(this.placeId);

  @override
  List<Object> get props => [placeId];

  @override
  String toString() => 'HomeLocationSelected { Place ID: $placeId }';
}

class SearchHomePlaces extends HomeFeedEvent {
  final String query;

  SearchHomePlaces(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchHomePlaces { Query: $query }';
}

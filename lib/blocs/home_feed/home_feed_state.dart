part of 'home_feed_bloc.dart';

@immutable
abstract class HomeFeedState {}

class FeaturedListingLoadInProgress extends HomeFeedState {}

class FeaturedListingLoadError extends HomeFeedState {
  final String errorMessage;

  FeaturedListingLoadError([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];
}

class FeaturedListingLoadSuccess extends HomeFeedState {
  final List<QueryDocumentSnapshot<Listing>> listings;

  FeaturedListingLoadSuccess(this.listings);

  @override
  List<Object?> get props => [listings];
}
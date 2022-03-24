part of 'listing_compose_bloc.dart';

@immutable
abstract class ListingComposeState {}

class ListingComposeInitial extends ListingComposeState {}

class AddressLoadInProgress extends ListingComposeState {}

class AddressLoadError extends ListingComposeState {
  final String errorMessage;

  AddressLoadError([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];
}

class AddressLoadSuccess extends ListingComposeState {
  final List<PlaceSearch>? places;

  AddressLoadSuccess(this.places);

  @override
  List<Object?> get props => [places];
}

class AddressUpdated extends ListingComposeState {
  final Place? address;

   AddressUpdated(this.address);

  @override
  List<Object?> get props => [address];
}

class ListingUploadInProgress extends ListingComposeState {}

class ListingUploadSuccess extends ListingComposeState {}

class ListingUploadError extends ListingComposeState {
  final String errorMessage;

   ListingUploadError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AuthenticatingUser extends ListingComposeState{}
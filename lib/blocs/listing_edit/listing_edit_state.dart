part of 'listing_edit_bloc.dart';

@immutable
abstract class ListingEditState {}

class ListingEditInitial extends ListingEditState {}

class AddressLoadInProgressEditing extends ListingEditState {}

class AddressLoadErrorEditing extends ListingEditState {
  final String errorMessage;

  AddressLoadErrorEditing([this.errorMessage = '']);

  @override
  List<Object?> get props => [errorMessage];
}

class AddressLoadSuccessEditing extends ListingEditState {
  final List<PlaceSearch>? places;

  AddressLoadSuccessEditing(this.places);

  @override
  List<Object?> get props => [places];
}

class AddressUpdatedEditing extends ListingEditState {
  final Place? address;

  AddressUpdatedEditing(this.address);

  @override
  List<Object?> get props => [address];
}

class ListingUpdateInProgress extends ListingEditState {}

class ListingUpdateSuccess extends ListingEditState {}

class ListingUpdateError extends ListingEditState {
  final String errorMessage;

  ListingUpdateError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AuthenticatingUserEditListing extends ListingEditState {}

class ListingDeleteInProgress extends ListingEditState {}

class ListingDeleteError extends ListingEditState {
  final String errorMessage;

  ListingDeleteError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ListingDeleteSuccess extends ListingEditState {}

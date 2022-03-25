import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:roomr/blocs/listing_search/listing_search_bloc.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/listing_filter_settings.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/routes/routes.dart';
import 'package:roomr/widgets/listing_card_widget.dart';

class ListingFeedScreen extends StatefulWidget {
  ListingFeedScreen();

  @override
  _ListingFeedScreenState createState() => _ListingFeedScreenState();
}

class _ListingFeedScreenState extends State<ListingFeedScreen> {
  Place? location;
  ListingFilterSettings filters = new ListingFilterSettings();
  String userId = '';
  TextEditingController searchTextController = new TextEditingController();
  final kMobileBreakpoint = 576;
  final kTabletBreakpoint = 1024;
  final kDesktopBreakPoint = 1366;
  AuthState _authState = Get.find();

  @override
  void initState() {
    BlocProvider.of<ListingSearchBloc>(context)
        .add(LoadListingsWithFilters(null, null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Get User Id before showing listings
    _getUserId(context);

    return BlocConsumer<ListingSearchBloc, ListingSearchState>(
        listener: (context, state) {
      if (state is SettingListingSearchLocation) {
        this.location = state.location;

        if (state.location != null) {
          this.searchTextController.text = state.location!.name;
        } else {
          this.searchTextController.text = "";
        }

        BlocProvider.of<ListingSearchBloc>(context)
            .add(LoadListingsWithFilters(this.filters, this.location));
      }
    }, builder: (context, state) {
      if (state is ListingLoadInProgress ||
          state is ListingLoadError ||
          state is ListingLoadSuccess) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Listings"),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Column(children: [
              Padding(
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Filter by location'),
                    onChanged: (value) {
                      BlocProvider.of<ListingSearchBloc>(context)
                          .add(SearchPlaces(value));
                    },
                    controller: searchTextController,
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
              Padding(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey),
                                ),
                                onPressed: () {
                                  debugPrint('Received showing filters click');
                                  _getFilters(context);
                                },
                                child: const Text(
                                  'Update Filters',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0))),
                      Expanded(
                          child: Padding(
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey),
                                ),
                                onPressed: () {
                                  debugPrint('Received reset filters click');
                                  this.filters = new ListingFilterSettings();
                                  BlocProvider.of<ListingSearchBloc>(context)
                                      .add(LoadListingsWithFilters(
                                          null, this.location));
                                },
                                child: const Text('Reset Filters',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0)))
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 10)),
              if (state is ListingLoadInProgress) CircularProgressIndicator(),
              if (state is ListingLoadError)
                Text('No listings found. Try a different search.'),
              if (state is ListingLoadSuccess)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, dimens) {
                      if (dimens.maxWidth <= kMobileBreakpoint) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: 300.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListingCardWidget(
                              editable: state.listings[index].data().ownerUid ==
                                  userId,
                              listingData: Listing.fromJson(
                                  state.listings[index].data().toJson()),
                              listingId: state.listings[index].id,
                            );
                          },
                          itemCount: state.listings.length,
                        );
                      } else if (dimens.maxWidth > kMobileBreakpoint &&
                          dimens.maxWidth <= kTabletBreakpoint) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 300.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListingCardWidget(
                              editable: state.listings[index].data().ownerUid ==
                                  userId,
                              listingData: Listing.fromJson(
                                  state.listings[index].data().toJson()),
                              listingId: state.listings[index].id,
                            );
                          },
                          itemCount: state.listings.length,
                        );
                      } else if (dimens.maxWidth > kTabletBreakpoint &&
                          dimens.maxWidth <= kDesktopBreakPoint) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 300.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListingCardWidget(
                              editable: state.listings[index].data().ownerUid ==
                                  userId,
                              listingData: Listing.fromJson(
                                  state.listings[index].data().toJson()),
                              listingId: state.listings[index].id,
                            );
                          },
                          itemCount: state.listings.length,
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisExtent: 300.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListingCardWidget(
                              editable: state.listings[index].data().ownerUid ==
                                  userId,
                              listingData: Listing.fromJson(
                                  state.listings[index].data().toJson()),
                              listingId: state.listings[index].id,
                            );
                          },
                          itemCount: state.listings.length,
                        );
                      }
                    },
                  ),
                ),
            ]));
      } else if (state is PlacesLoadInProgress ||
          state is PlacesLoadError ||
          state is PlacesLoadSuccess) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Listings"),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Column(children: [
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Filter by location'),
                onChanged: (value) =>
                    BlocProvider.of<ListingSearchBloc>(context)
                        .add(SearchPlaces(value)),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  debugPrint('Received showing filters click');
                  _getFilters(context);
                },
                child: Text('Show More Filters'),
              ),
              if (state is PlacesLoadInProgress)
                Expanded(
                    child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.blueGrey),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                  Container(
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/powered_by_google_on_non_white@3x.png',
                        width: 150,
                      )),
                ])),
              if (state is PlacesLoadError)
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(color: Colors.blueGrey),
                        child: Text('No Locations Found For Search'))),
              if (state is PlacesLoadSuccess)
                Expanded(
                  child: Stack(children: [
                    Container(
                        decoration: BoxDecoration(color: Colors.blueGrey),
                        child: ListView.builder(
                            itemCount: state.places!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  state.places![index].description,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  BlocProvider.of<ListingSearchBloc>(context)
                                      .add(LocationSelected(
                                          state.places![index].placeId));
                                },
                              );
                            })),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/powered_by_google_on_non_white@3x.png',
                        width: 150,
                      ),
                    )
                  ]),
                ),
            ]));
      } else {
        // Default case
        return Scaffold(
            body: Column(children: [
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Filter by location'),
            onChanged: (value) {
              BlocProvider.of<ListingSearchBloc>(context)
                  .add(SearchPlaces(value));
            },
            controller: searchTextController,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              debugPrint('Received showing filters click');
              _getFilters(context);
            },
            child: Text('Show More Filters'),
          ),
          Expanded(
            child: Text('Search a location for listings'),
          ),
        ]));
      }
    });
  }

  void _getFilters(BuildContext context) async {
    ListingFilterSettings? filters =
        await Get.toNamed(AppRoutes.listingFilters, arguments: this.filters)
            as ListingFilterSettings?;

    print('Filters:' + filters.toString());
    if (filters != null) {
      this.filters = filters;
      BlocProvider.of<ListingSearchBloc>(context)
          .add(LoadListingsWithFilters(this.filters, this.location));
    } else {
      this.filters = new ListingFilterSettings();
    }
  }

  void _getUserId(BuildContext context) {
    if (_authState.isAuthenticated) {
      try {
        print('Getting user Id');

        User? user = _authState.currentUser;

        if (user != null) {
          this.userId = user.uid;
          print('User Id:' + this.userId);
        } else {
          print('User Id not found');
        }
      } catch (error) {
        print('Error:' + error.toString());
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchTextController.dispose();
    super.dispose();
  }
}

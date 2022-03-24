import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomr/blocs/home_feed/home_feed_bloc.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/model/address.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import 'package:roomr/model/geometry.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/location.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/routes/routes.dart';
import 'package:roomr/widgets/listing_card_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = '';
  String placeName = "";
  late Place location;
  TextEditingController searchTextController = new TextEditingController();
  AuthState _authState = Get.find<AuthState>();

  final kMobileBreakpoint = 576;
  final kTabletBreakpoint = 1024;
  final kDesktopBreakPoint = 1366;

  @override
  void initState() {
    loadListings();
    super.initState();
  }

  void loadListings() async {
    setState(() {
      //Setup default search location
      final Geometry geometry = new Geometry(
          location: new Location(lat: 40.233779, lng: -111.658672));
      final Address address = new Address();
      address.city = "Provo";
      address.state = "Utah";

      this.location = new Place(
          geometry: geometry,
          name: "Provo, Utah",
          vicinity: "",
          address: address);
    });
    print(this.location);

    this.placeName = this.placeName =
        this.location.address.city + "," + this.location.address.state;
    BlocProvider.of<HomeFeedBloc>(context).add(LoadFeaturedListings());
  }

  List<QueryDocumentSnapshot<Listing>> listingData = [];

  @override
  Widget build(BuildContext context) {
    //Get User Id before showing listings
    _getUserId(context);

    return BlocBuilder<HomeFeedBloc, HomeFeedState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Roomr"),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Column(children: [
          if (state is FeaturedListingLoadError)
            Expanded(
              child: Text('There was an error loading listings'),
            ),
          if (state is FeaturedListingLoadSuccess && state.listings.length > 0)
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
                          editable:
                              state.listings[index].data().ownerUid == userId,
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
                          editable:
                              state.listings[index].data().ownerUid == userId,
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
                          editable:
                              state.listings[index].data().ownerUid == userId,
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
                          editable:
                              state.listings[index].data().ownerUid == userId,
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
          if (state is FeaturedListingLoadSuccess && state.listings.length == 0)
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      child: Text(
                        "There aren't any listings yet...  \n be the first!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                  ),
                  Center(
                      child: Container(
                          height: 200,
                          width: 350,
                          child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Received create listing click');
                                if (_authState.isAuthenticated) {
                                  Get.toNamed(AppRoutes.composeListing);
                                } else {
                                  Get.toNamed(
                                    AppRoutes.authSelect,
                                    arguments: AuthScreenSettings(
                                        destinationScreen:
                                            AppRoutes.composeListing),
                                  );
                                }
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        child: Text(
                                          "Create a Listing",
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            20, 10, 20, 10)),
                                    Padding(
                                        child: Icon(Icons.house,
                                            size: 70, color: Colors.white),
                                        padding: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10)),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: Colors.lightBlue,
                                shadowColor: Colors.black,
                              )))),
                ],
              ),
            ),
          if (state is FeaturedListingLoadInProgress)
            Center(
              child: CircularProgressIndicator(),
            ),
        ]),
      );
    });
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

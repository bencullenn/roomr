import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roomr/model/account.dart';
import 'package:roomr/model/edit_listing_args.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/listing_detail_settings.dart';
import 'package:roomr/routes/routes.dart';
import 'package:roomr/services/data_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';

import '../widgets/loading_dialog_widget.dart';

class ListingDetailScreen extends StatefulWidget {
  ListingDetailScreen();

  @override
  _ListingDetailScreenState createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late final editable;
  late final Listing listingData;
  late final String listingId;
  late final String popUntilScreen;
  bool dataUpdated = false;
  late final bool showAmenities;
  CarouselController photoCarouselController = CarouselController();
  CarouselController matchesCarouselController = CarouselController();

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      _showErrorDialog("Contact Seller Error", onError.toString());
    });
    print(_result);
  }

  void _contactSeller() async {
    final DataService dataService = Get.find<DataService>();
    Account? account;
    try {
      account = await dataService.getAccountForUserId(listingData.ownerUid);
    } catch (error) {
      _showErrorDialog("Contact Seller Error", error.toString());
    }

    if (account != null) {
      if (account.prefContactMethod == 'Email') {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: account.email,
          query: encodeQueryParameters(
              <String, String>{'subject': 'Question about your Roomr listing'}),
        );
        await canLaunch(emailLaunchUri.toString())
            ? await launch(emailLaunchUri.toString())
            : _showErrorDialog("Contact Seller Error",
                "Could not create email link for seller");
      } else if (account.prefContactMethod == 'Phone Call' ||
          account.prefContactMethod == 'Text-Message') {
        _sendSMS("I saw your listing on Roomr. Is it still available?",
            [account.mobileNumber.substring(1)]);
      } else {
        _showErrorDialog("Contact Seller Error",
            "There was an error getting the seller's information");
      }
    } else {
      _showErrorDialog("Contact Seller Error",
          "There was an error getting the seller's information");
    }
  }

  void _updateDetails(ListingDetailSettings args) {
    if (dataUpdated == false) {
      this.editable = args.editable;
      this.listingData = args.listingData;
      this.listingId = args.listingId;
      this.popUntilScreen = args.popUntilScreen;
      this.showAmenities = listingData.hasAC == true ||
          listingData.petsAllowed == true ||
          listingData.parkingType != "None" ||
          listingData.hasGym == true ||
          listingData.hasPool == true ||
          listingData.hasHotTub == true ||
          listingData.laundryType != "None" ||
          listingData.hasDishwasher == true ||
          listingData.hasWifi == true ||
          listingData.isFurnished == true;
      this.dataUpdated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ListingDetailSettings;

    _updateDetails(args);
    return Scaffold(
        appBar: AppBar(
            title: Text(listingData.formattedAddress,
                style: Theme.of(context).textTheme.headline6),
            actions: <Widget>[
              if (editable)
                IconButton(
                  icon: Icon(Icons.mode_edit),
                  onPressed: () {
                    print('Edit Button Pressed');
                    Get.toNamed(AppRoutes.editListing,
                        arguments: EditListingArguments(
                            listingId, listingData, popUntilScreen));
                  },
                ),
            ]),
        body: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(
            //minHeight: 50.0,
            maxWidth: 500.0,
          ),
          child: Container(
            child: ListView(children: [
              Container(
                height: 250,
                width: 500,
                child: CarouselSlider.builder(
                  itemCount: listingData.photos.length,
                  carouselController: photoCarouselController,
                  options: CarouselOptions(
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Container(
                    child: Image(
                      image: NetworkImage(listingData.photos[itemIndex]),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      photoCarouselController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blueGrey,
                      size: 30.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      photoCarouselController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueGrey,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          child: OutlinedButton(
                            onPressed: () {
                              debugPrint('Received contact seller click');
                              _contactSeller();
                            },
                            child: const Text(
                              'Contact Seller',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueGrey)),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10))),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: Padding(
                    child:
                        Text('\$' + listingData.rent.toString() + ' Monthly'),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  ))),
                  Expanded(
                      child: Center(
                          child: Padding(
                              child: Text('Available ' +
                                  DateFormat('MM-dd-yyyy').format(
                                      listingData.dateAvailable.toDate())),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5))))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: Padding(
                    child: Text(listingData.contractType),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ))),
                  Expanded(
                      child: Center(
                          child: Padding(
                              child: Text(listingData.roomType),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10))))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: Padding(
                    child:
                        Text(listingData.bedroomCount.toString() + ' Bedroom '),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ))),
                  Expanded(
                      child: Center(
                          child: Padding(
                    child: Text(
                        listingData.bathroomCount.toString() + ' Bathroom'),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ))),
                ],
              ),
              listingData.description.length > 0
                  ? Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Padding(
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10))))
                      ],
                    )
                  : Container(),
              listingData.description.length > 0
                  ? Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Padding(
                                    child: Container(
                                      child: Text(listingData.description),
                                    ),
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10))))
                      ],
                    )
                  : Container(),
              if (showAmenities)
                Row(children: [
                  Expanded(
                      child: Center(
                          child: Padding(
                              child: Text(
                                'Amenities and Features',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10))))
                ]),
              Visibility(
                  child: Column(
                    children: [
                      listingData.hasAC == true
                          ? ListTile(
                              leading: Icon(Icons.ac_unit),
                              title: Text('Air Conditioning'),
                            )
                          : Container(),
                      listingData.petsAllowed == true
                          ? ListTile(
                              leading: Icon(Icons.pets),
                              title: Text('Pets Allowed'),
                            )
                          : Container(),
                      listingData.parkingType == 'Off Street'
                          ? ListTile(
                              leading: Icon(Icons.directions_car),
                              title: Text('Off Street Parking'),
                            )
                          : Container(),
                      listingData.parkingType == 'Street Parking'
                          ? ListTile(
                              leading: Icon(Icons.directions_car),
                              title: Text('Street Parking'),
                            )
                          : Container(),
                      listingData.parkingType == 'Garage'
                          ? ListTile(
                              leading: Icon(Icons.directions_car),
                              title: Text('Garage Parking'),
                            )
                          : Container(),
                      listingData.hasGym == true
                          ? ListTile(
                              leading: Icon(Icons.directions_run),
                              title: Text('Gym'),
                            )
                          : Container(),
                      listingData.hasPool == true
                          ? ListTile(
                              leading: Icon(Icons.pool),
                              title: Text('Pool'),
                            )
                          : Container(),
                      listingData.hasHotTub == true
                          ? ListTile(
                              leading: Icon(Icons.hot_tub),
                              title: Text('Hot Tub'),
                            )
                          : Container(),
                      listingData.laundryType == "Shared"
                          ? ListTile(
                              leading: Icon(Icons.local_laundry_service),
                              title: Text('Shared Laundry'),
                            )
                          : Container(),
                      listingData.laundryType == "In Unit"
                          ? ListTile(
                              leading: Icon(Icons.local_laundry_service),
                              title: Text('In Unit Laundry'),
                            )
                          : Container(),
                      listingData.hasWifi == true
                          ? ListTile(
                              leading: Icon(Icons.wifi),
                              title: Text('Wifi'),
                            )
                          : Container(),
                      listingData.hasDishwasher == true
                          ? ListTile(
                              leading: Icon(Icons.dining),
                              title: Text('Dishwasher'),
                            )
                          : Container(),
                      listingData.isFurnished == true
                          ? ListTile(
                              leading: Icon(Icons.chair_rounded),
                              title: Text('Furnished'),
                            )
                          : Container(),
                    ],
                  ),
                  visible: showAmenities),
            ]),
          ),
        )));
  }

  Future<void> _showErrorDialog(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showContactDialog(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

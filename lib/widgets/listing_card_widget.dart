import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/listing_detail_settings.dart';
import 'package:roomr/routes/routes.dart';

class ListingCardWidget extends StatelessWidget {
  final Listing listingData;
  final bool editable;
  final String listingId;
  final String popUntilScreen;

  ListingCardWidget(
      {required this.listingData,
      required this.editable,
      required this.listingId,
      this.popUntilScreen = "/"});

  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Listing Card tapped.');
          Get.toNamed(AppRoutes.listingDetails,
              arguments: ListingDetailSettings(
                  editable: editable,
                  listingData: listingData,
                  listingId: listingId,
                  popUntilScreen: popUntilScreen));
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (this.listingData.status == 'Pending' ||
                  this.listingData.status == 'Sold')
                Center(
                    child: Padding(
                  child: Text(
                    "Status:" + this.listingData.status,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                )),
              Container(
                child: Image(
                  image: NetworkImage(this.listingData.photos[0]),
                  fit: BoxFit.fill,
                ),
                height: 200,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: Padding(
                    child: Text(
                      this.listingData.formattedAddress,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  ))),
                  Expanded(
                      child: Center(
                          child: Padding(
                    child: Text(
                      '\$' + this.listingData.rent.toString(),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  ))),
                  Expanded(
                      child: Center(
                          child: Padding(
                    child: Text(
                        'Available \n' +
                            DateFormat('MM-dd-yyyy').format(
                                this.listingData.dateAvailable.toDate()),
                        textAlign: TextAlign.center),
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  ))),
                ],
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.black,
          color: Colors.blueGrey[100],
        ));
  }
}

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

class CreateSelectScreen extends StatefulWidget {
  CreateSelectScreen();

  @override
  _CreateSelectScreenState createState() => _CreateSelectScreenState();
}

class _CreateSelectScreenState extends State<CreateSelectScreen> {
  AuthState _authState = Get.find<AuthState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: 50,
        ),
        Expanded(
          child: ListView(
            children: [
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
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10)),
                                Padding(
                                    child: Icon(Icons.house,
                                        size: 70, color: Colors.white),
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10)),
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
      ]),
    );
  }
}

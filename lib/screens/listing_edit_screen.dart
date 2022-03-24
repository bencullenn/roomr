import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:roomr/blocs/home_feed/home_feed_bloc.dart';
import 'package:roomr/blocs/listing_edit/listing_edit_bloc.dart';
import 'package:roomr/blocs/listing_search/listing_search_bloc.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import 'package:roomr/model/edit_listing_args.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/model/place_search.dart';
import 'package:roomr/routes/routes.dart';
import 'package:roomr/screens/checkbox_widget.dart';
import 'package:roomr/widgets/loading_dialog_widget.dart';

class ListingEditScreen extends StatefulWidget {
  ListingEditScreen();

  @override
  _ListingEditScreenState createState() => _ListingEditScreenState();
}

class _ListingEditScreenState extends State<ListingEditScreen> {
  final _formKey = GlobalKey<FormState>();
  List<PlaceSearch>? searchResults;
  Place? listingAddress;
  TextEditingController addressController = new TextEditingController();
  String popUntilScreen = "/";
  late final Place defaultPlace = Get.find();

  // ignore: non_constant_identifier_names
  bool BYUApproved = false;
  bool hasAC = false;
  bool hasHotTub = false;
  bool hasPool = false;
  bool hasGym = false;
  bool hasDishwasher = false;
  bool hasWifi = false;
  bool instantNotify = false;
  bool isFurnished = false;
  bool petsAllowed = false;
  List<String> roomOptions = ['Shared Room', 'Private Room', 'Entire Unit'];
  List<String> parkingOptions = [
    'Street Parking',
    'Off-street Parking',
    'Garage Parking',
    'None'
  ];
  List<String> contractOptions = ['Co-Ed', 'Male', 'Female', 'Family'];
  List<String> listingStatusOptions = ['Available', 'Pending', 'Sold'];
  List<String> laundryTypes = ['None', 'Shared', 'In Unit'];
  String roomType = 'Shared Room';
  String parkingType = 'Street Parking';
  String contractType = 'Co-Ed';
  String laundryType = 'None';
  String address = '';
  String rent = '';
  String utilities = '';
  String incentive = '';
  String bathAmt = '';
  String bedAmt = '';
  String deposit = '';
  String description = '';
  String listingStatus = '';
  DateTime availableDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageMobileFileList;
  dynamic _pickImageError;
  String? _retrieveDataError;
  String? listingId;
  bool dataUpdated = false;
  bool changePhotos = false;
  List<String> oldImageLinks = [];
  AuthState _authState = Get.find();

  set _imageMobileFile(XFile? value) {
    _imageMobileFileList = value == null ? null : [value];
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditListingArguments;

    _updateDetails(args);

    return BlocConsumer<ListingEditBloc, ListingEditState>(
        listener: (context, state) {
      if (state is AddressLoadSuccessEditing) {
        setState(() {
          searchResults = state.places;
        });
      } else if (state is AddressUpdatedEditing) {
        setState(() {
          addressController.text = state.address!.name;
          listingAddress = state.address;
          searchResults = null;
        });
      } else if (state is ListingUpdateInProgress) {
        showUploaderLoaderDialog(context);
      } else if (state is ListingDeleteInProgress) {
        showDeleteLoaderDialog(context);
      } else if (state is ListingUpdateError) {
        Navigator.pop(context);
        _showErrorDialog(
            'Update Error', 'Error updating listing:' + state.errorMessage);
      } else if (state is ListingUpdateSuccess) {
        Navigator.pop(context);
        _showSuccessDialog('Listing Updated', 'Listing successfully updated');
      } else if (state is ListingDeleteError) {
        Navigator.pop(context);
        _showErrorDialog(
            'Delete Error', 'Error deleting listing:' + state.errorMessage);
      } else if (state is ListingDeleteSuccess) {
        Navigator.pop(context);
        _showSuccessDialog('Listing Deleted', 'Listing successfully deleted');
      } else if (state is AuthenticatingUserEditListing) {
        Get.toNamed(AppRoutes.authSelect,
            arguments: AuthScreenSettings(returnScreen: AppRoutes.editListing));
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Edit Listing', style:  Theme.of(context).textTheme.headline6),
            leading: Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    print('Canceling filter update');
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                );
              },
            ),
            leadingWidth: 100,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: TextButton(
                  onPressed: () {
                    print('Saving listing');
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _updateListing(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Invalid Data. Check listing and try again.')),
                      );
                    }
                  },
                  child: Text("Save"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              )
            ],
          ),
          body: Form(
              key: _formKey,
              child: Center(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        child: Text(
                          'Update your Listing  \n and tap Save when you\'re done',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.00),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 30)),
                    if (_imageMobileFileList != null && _imageMobileFileList!.length > 0)
                      Padding(
                          child: _previewImages(),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    if (_imageMobileFileList == null || _imageMobileFileList!.length == 0)
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                          alignment: Alignment.center,
                          child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Received upload click');
                                  _showPhotoPicker(context);
                                setState(() {
                                  this.changePhotos = true;
                                });
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      alignment: Alignment.center,
                                      child: Icon(Icons.photo,
                                          color: Colors.white, size: 60.00),
                                    ),
                                    Padding(
                                      child: Text(
                                        'Replace Current Photos',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                color: Colors.blueGrey,
                                shadowColor: Colors.black,
                              ))),
                    if (_imageMobileFileList != null && _imageMobileFileList!.length > 0)
                      Padding(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey),
                            ),
                            onPressed: () {
                              debugPrint('Received upload click');
                                _showPhotoPicker(context);
                            },
                            child: Text(
                              'Re-Select Photos',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
                    Row(children: [
                      Padding(
                          child: Text("Property Address"),
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 5))
                    ]),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Property Address'),
                          controller: addressController,
                          onSaved: (String? value) {
                            setState(() {
                              address = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              BlocProvider.of<ListingEditBloc>(context)
                                  .add(SearchAddressesEditing(value)),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    if (searchResults != null && searchResults?.length != 0)
                      Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(color: Colors.blueGrey),
                              child: Stack(children: [
                                ListView.builder(
                                    itemCount: searchResults!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          searchResults![index].description,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: () {
                                          BlocProvider.of<ListingEditBloc>(
                                                  context)
                                              .add(AddressSelectedEditing(
                                                  searchResults![index]
                                                      .placeId));
                                        },
                                      );
                                    }),
                                Container(
                                    padding: const EdgeInsets.all(5.0),
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(
                                      'assets/powered_by_google_on_non_white@3x.png',
                                      width: 150,
                                    )),
                              ]),
                              height: 300.0),
                        ],
                      ),
                    Row(children: [
                      Padding(
                          child: Text(
                              "Rent Cost Per Month (Not Including Utilities)"),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5))
                    ]),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:
                                  'Rent Cost Per Month (Not Including Utilities)'),
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              symbol: '\$',
                              decimalDigits: 0,
                            )
                          ],
                          keyboardType: TextInputType.number,
                          initialValue: this.rent,
                          onSaved: (String? value) {
                            setState(() {
                              rent = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    Row(children: [
                      Padding(
                          child: Text("Average Utilities Cost Per Month"),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5))
                    ]),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Average Utilities Cost Per Month'),
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              symbol: '\$',
                              decimalDigits: 0,
                            )
                          ],
                          keyboardType: TextInputType.number,
                          initialValue: this.utilities,
                          onSaved: (String? value) {
                            setState(() {
                              utilities = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Row(
                      children: [
                        Padding(
                            child: Text('Date Available: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                        Padding(
                            child: Text(
                                DateFormat('MM-dd-yyyy').format(availableDate)),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    Padding(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            debugPrint('Received change date click');
                            _selectDate(context);
                          },
                          child: Text('Select Date'),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          children: [
                            Text('Status: '),
                            DropdownButton<String>(
                              value: listingStatus,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: Colors.blueAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  listingStatus = newValue!;
                                });
                              },
                              items: listingStatusOptions
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Text('Room Type: '),
                            DropdownButton<String>(
                              value: roomType,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: Colors.blueAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  roomType = newValue!;
                                });
                              },
                              items: roomOptions
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Text('Contract Type: '),
                            DropdownButton<String>(
                              value: contractType,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: Colors.blueAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  contractType = newValue!;
                                });
                              },
                              items: contractOptions
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        )),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Row(children: [
                      Padding(
                          child: Text("Amount of Bathrooms"),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5))
                    ]),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Amount of Bathrooms'),
                          keyboardType: TextInputType.number,
                          initialValue: this.bathAmt,
                          onSaved: (String? value) {
                            setState(() {
                              bathAmt = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    Row(children: [
                      Padding(
                          child: Text("Amount of Bedrooms"),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5))
                    ]),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Amount of Bedrooms'),
                          keyboardType: TextInputType.number,
                          initialValue: this.bedAmt,
                          onSaved: (String? value) {
                            setState(() {
                              bedAmt = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    Row(children: [
                      Padding(
                          child: Text("Listing Description"),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5))
                    ]),
                    Padding(
                        child: Container(
                            child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description',
                          ),
                          maxLines: 3,
                          initialValue: this.description,
                          onSaved: (String? value) {
                            setState(() {
                              description = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            /*if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                             */
                          },
                        )),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 10)),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Padding(
                        child: Center(
                            child: Text(
                          'Advanced Details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Text('Parking Type: '),
                            DropdownButton<String>(
                              value: parkingType,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: Colors.blueAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  parkingType = newValue!;
                                });
                              },
                              items: parkingOptions
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Text('Laundry Type: '),
                            DropdownButton<String>(
                              value: laundryType,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: Colors.blueAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  laundryType = newValue!;
                                });
                              },
                              items: laundryTypes
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        )),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Instant Notify',
                            updateFunction: (value) {
                              setState(() {
                                this.instantNotify = value;
                              });
                            },
                            initialValue: this.instantNotify),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Air Conditioning',
                            updateFunction: (value) {
                              setState(() {
                                this.hasAC = value;
                              });
                            },
                            initialValue: this.hasAC),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Pets Allowed',
                            updateFunction: (value) {
                              setState(() {
                                this.petsAllowed = value;
                              });
                            },
                            initialValue: this.petsAllowed),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Wifi',
                            updateFunction: (value) {
                              setState(() {
                                this.hasWifi = value;
                              });
                            },
                            initialValue: this.hasWifi),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Dishwasher',
                            updateFunction: (value) {
                              setState(() {
                                this.hasDishwasher = value;
                              });
                            },
                            initialValue: this.hasDishwasher),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Furnished',
                            updateFunction: (value) {
                              setState(() {
                                this.isFurnished = value;
                              });
                            },
                            initialValue: this.isFurnished),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Hot Tub',
                            updateFunction: (value) {
                              setState(() {
                                this.hasHotTub = value;
                              });
                            },
                            initialValue: this.hasHotTub),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Gym',
                            updateFunction: (value) {
                              setState(() {
                                this.hasGym = value;
                              });
                            },
                            initialValue: this.hasGym),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Pool',
                            updateFunction: (value) {
                              setState(() {
                                this.hasPool = value;
                              });
                            },
                            initialValue: this.hasPool),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        debugPrint('Received delete listing click');
                        _showConfirmDeleteDialog();
                      },
                      child: Text(
                        'Delete Listing',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 50,
                    )
                  ],
                ),
              ))));
    });
  }

  Future<void> _updateListing(BuildContext context) async {
    if (_authState.isAuthenticated) {
      try {
        print("Saving listing");
        User? user = _authState.currentUser;
        String userUid = '';

        if (user != null) {
          userUid = user.uid;
        }

        BlocProvider.of<ListingEditBloc>(context).add(UpdateListing(
            address: listingAddress,
            incentive: incentive,
            roomType: roomType,
            description: description,
            parkingType: parkingType,
            contractType: contractType,
            rent: rent.replaceAll(RegExp(r'[^0-9]'), ''),
            utilities: utilities.replaceAll(RegExp(r'[^0-9]'), ''),
            bedroomCount: bedAmt,
            bathroomCount: bathAmt,
            petsAllowed: petsAllowed,
            hasGym: hasGym,
            hasPool: hasPool,
            hasHotTub: hasHotTub,
            laundryType: laundryType,
            hasWifi: hasWifi,
            hasDishwasher: hasDishwasher,
            instantNotify: instantNotify,
            isFurnished: isFurnished,
            hasAC: hasAC,
            byuIdahoApproved: false,
            byuHawaiiApproved: false,
            byuProvoApproved: false,
            ownerUid: userUid,
            listingId: this.listingId,
            listingStatus: this.listingStatus,
            newMobilePhotoFiles: _imageMobileFileList,
            oldPhotoLinks: oldImageLinks,
            changePhotos: changePhotos));
        print("Listing saved");
      } catch (error) {
        print(error);
      }
    } else {
      BlocProvider.of<ListingEditBloc>(context)
          .add(AuthorizeUserListingEditing());
    }
  }

  void _updateDetails(EditListingArguments args) {
    print("Pop screen:" + args.popUntilScreen);
    if (dataUpdated == false) {
      this.description = args.listingData.description;
      this.listingId = args.listingId;
      this.listingStatus = args.listingData.status;
      this.popUntilScreen = args.popUntilScreen;
      this.oldImageLinks = args.listingData.photos.cast<String>();

      this.dataUpdated = true;
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: availableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    );
    if (picked != null && picked != availableDate)
      setState(() {
        availableDate = picked;
      });
  }

  void _showPhotoPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _onImageButtonPressed(
                          ImageSource.gallery,
                          context: context,
                          isMultiImage: true,
                        );
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final pickedFileList = await _picker.pickMultiImage(
          maxWidth: 1080,
          maxHeight: 1080,
          imageQuality: 50,
        );
        print('Picked pictures count:' + pickedFileList!.length.toString());
        if (mounted) {
          setState(() {
            _imageMobileFileList = pickedFileList;
          });
        }
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1080,
          maxHeight: 1080,
          imageQuality: 50,
        );
        setState(() {
          _imageMobileFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Widget photoView() {
    return Center(
      child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    );
                  case ConnectionState.done:
                    return _previewImages();
                  default:
                    if (snapshot.hasError) {
                      return Text(
                        'Pick image/video error: ${snapshot.error}}',
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    }
                }
              },
            )
          : _previewImages(),
    );
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();

    if (retrieveError != null) {
      return retrieveError;
    }

    if (_imageMobileFileList != null) {
      print("File list length:" + _imageMobileFileList!.length.toString());
      return Semantics(
        child: CarouselSlider.builder(
          key: UniqueKey(),
          options: CarouselOptions(
            enableInfiniteScroll: false,
          ),
          itemCount: _imageMobileFileList!.length,
          itemBuilder: (context, index, pageViewIndex) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return Container(
              child: kIsWeb
                  ? Image.network(_imageMobileFileList![index].path)
                  : Image.file(File(_imageMobileFileList![index].path)),
            );
          },
        ),
      );
    } if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked any images.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageMobileFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  showUploaderLoaderDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialogWidget("Updating Listing");
        });
  }

  showDeleteLoaderDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialogWidget("Deleting Listing");
        });
  }

  Future<void> _showSuccessDialog(String title, String content) async {
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
              child: const Text('Okay'),
              onPressed: () {
                BlocProvider.of<HomeFeedBloc>(context)
                    .add(LoadFeaturedListings());
                BlocProvider.of<ListingSearchBloc>(context)
                    .add(LoadListingsWithFilters(null, null));
                Navigator.popUntil(
                    context, ModalRoute.withName(popUntilScreen));
              },
            ),
          ],
        );
      },
    );
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
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete your listing?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("This is permanent and cannot be undone."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                BlocProvider.of<ListingEditBloc>(context).add(
                    DeleteListing(this.listingId ?? "", this.oldImageLinks));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addressController.dispose();
    super.dispose();
  }
}

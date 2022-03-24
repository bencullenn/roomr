import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
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
import 'package:roomr/blocs/listing_compose/listing_compose_bloc.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import 'package:roomr/model/place.dart';
import 'package:roomr/model/place_search.dart';
import 'package:roomr/routes/routes.dart';
import 'package:roomr/screens/checkbox_widget.dart';
import 'package:roomr/widgets/loading_dialog_widget.dart';
import 'package:roomr/widgets/picker_widget.dart';

class ComposeListingScreen extends StatefulWidget {
  ComposeListingScreen();

  @override
  _ComposeListingScreenState createState() => _ComposeListingScreenState();
}

class _ComposeListingScreenState extends State<ComposeListingScreen> {
  final _formKey = GlobalKey<FormState>();
  List<PlaceSearch>? searchResults;
  Place? listingAddress;
  TextEditingController addressController = new TextEditingController();
  AuthState _authState = Get.find();

  // ignore: non_constant_identifier_names
  bool BYUApproved = false;
  bool hasAC = false;
  bool hasHotTub = false;
  bool hasPool = false;
  bool hasGym = false;
  bool hasDishwasher = false;
  bool hasWifi = false;
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
  bool instantNotify = true;
  DateTime availableDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageMobileFileList;
  dynamic _pickImageError;
  String? _retrieveDataError;

  set _imageMobileFile(XFile? value) {
    _imageMobileFileList = value == null ? null : [value];
  }

  Future<void> _uploadListing(BuildContext context) async {
    if (_authState.isAuthenticated) {
      try {
        User? user = _authState.currentUser;
        String userUid = '';

        if (user != null) {
          userUid = user.uid;
        }

        BlocProvider.of<ListingComposeBloc>(context).add(UploadListing(
            imageMobileFileList: _imageMobileFileList,
            address: listingAddress,
            incentive: incentive,
            roomType: roomType,
            description: description,
            dateAvailable: Timestamp.fromDate(availableDate),
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
            hasDishwasher: hasDishwasher,
            hasWifi: hasWifi,
            isFurnished: isFurnished,
            hasAC: hasAC,
            byuIdahoApproved: false,
            byuHawaiiApproved: false,
            byuProvoApproved: false,
            ownerUid: userUid,
            instantNotify: instantNotify));
      } catch (error) {
        print(error);
      }
    } else {
      BlocProvider.of<ListingComposeBloc>(context).add(AuthorizeUserListing());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListingComposeBloc, ListingComposeState>(
        listener: (context, state) {
      if (state is AddressLoadSuccess) {
        setState(() {
          searchResults = state.places;
        });
      } else if (state is AddressUpdated) {
        setState(() {
          addressController.text = state.address!.name;
          listingAddress = state.address;
          searchResults = null;
        });
      } else if (state is ListingUploadInProgress) {
        showUploadingListingDialog(context);
      } else if (state is ListingUploadError) {
        Navigator.pop(context);
        _showErrorDialog(
            'Upload Error', 'Error uploading listing:' + state.errorMessage);
      } else if (state is ListingUploadSuccess) {
        Navigator.pop(context);
        _showSuccessDialog('Listing Uploaded',
            'We are looking for your matches. We\'ll send you a notification when they\'re ready.');
      } else if (state is AuthenticatingUser) {
        Get.toNamed(AppRoutes.authSelect,
            arguments: AuthScreenSettings(
                destinationScreen: AppRoutes.composeListing));
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Create Listing',
                style: Theme.of(context).textTheme.headline6),
          ),
          body: Form(
              key: _formKey,
              child: Center(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_imageMobileFileList != null &&
                            _imageMobileFileList!.length > 0)
                      Padding(
                          child: _previewImages(),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    if ((_imageMobileFileList == null))
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                          alignment: Alignment.center,
                          child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Received upload click');

                                  _showPhotoPicker(context);

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
                                        'Add Photos',
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
                    if ((_imageMobileFileList != null &&
                            _imageMobileFileList!.length > 0))
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
                              'Replace photos',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Property Address'),
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
                              BlocProvider.of<ListingComposeBloc>(context)
                                  .add(SearchAddresses(value)),
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
                                          BlocProvider.of<ListingComposeBloc>(
                                                  context)
                                              .add(AddressSelected(
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
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'Rent Cost Per Month (Not Including Utilities)'),
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              symbol: '\$',
                              decimalDigits: 0,
                            )
                          ],
                          keyboardType: TextInputType.number,
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
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Average Utilities Cost Per Month'),
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              symbol: '\$',
                              decimalDigits: 0,
                            )
                          ],
                          keyboardType: TextInputType.number,
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
                    Padding(
                        child: PickerWidget(
                            title: 'Room Type: ',
                            valueList: roomOptions,
                            updateFunction: (value) {
                              setState(() {
                                this.roomType = value;
                              });
                            }),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    Padding(
                        child: PickerWidget(
                            title: 'Contract Type: ',
                            valueList: contractOptions,
                            updateFunction: (value) {
                              setState(() {
                                this.contractType = value;
                              });
                            }),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    Row(
                      children: [
                        Padding(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                _showInstantNotifyDialog();
                              },
                              child: Icon(Icons.info),
                            ),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                        Padding(
                            child: CheckboxWidget(
                                title: 'Instant Notify',
                                updateFunction: (value) {
                                  setState(() {
                                    this.instantNotify = value;
                                  });
                                },
                                initialValue: instantNotify),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                      ],
                    ),
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount of Bathrooms'),
                          keyboardType: TextInputType.number,
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
                    Padding(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount of Bedrooms'),
                          keyboardType: TextInputType.number,
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
                    Padding(
                        child: Container(
                            child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                          maxLines: 3,
                          onSaved: (String? value) {
                            setState(() {
                              description = value ?? '';
                            });
                          },
                          validator: (String? value) {
                            return null;
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
                        child: Center(
                            child: Text(
                          'More detailed listings get more matches',
                        )),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: PickerWidget(
                            title: 'Parking Type: ',
                            valueList: parkingOptions,
                            updateFunction: (value) {
                              setState(() {
                                this.parkingType = value;
                              });
                            }),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: PickerWidget(
                            title: 'Laundry Type: ',
                            valueList: laundryTypes,
                            updateFunction: (value) {
                              setState(() {
                                this.laundryType = value;
                              });
                            }),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    /*Padding(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Deposit Amount'),
                controller: depositController,
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),*/
                    /*Padding(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Incentive'),
                controller: incentiveController,
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),*/
                    /*Padding(
              child: CheckboxWidget(
                title: 'BYU Approved',
                updateFunction: (value) {
                  setState(() {
                    this.BYUApproved = value;
                  });
                },
                initialValue: false,
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),*/
                    Padding(
                        child: CheckboxWidget(
                            title: 'Air Conditioning',
                            updateFunction: (value) {
                              setState(() {
                                this.hasAC = value;
                              });
                            },
                            initialValue: false),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Pets Allowed',
                            updateFunction: (value) {
                              setState(() {
                                this.petsAllowed = value;
                              });
                            },
                            initialValue: false),
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
                            initialValue: false),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Gym',
                            updateFunction: (value) {
                              setState(() {
                                this.hasGym = value;
                              });
                            },
                            initialValue: false),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: CheckboxWidget(
                            title: 'Pool',
                            updateFunction: (value) {
                              setState(() {
                                this.hasPool = value;
                              });
                            },
                            initialValue: false),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            debugPrint('Received upload post click');
                            if (_formKey.currentState!.validate()) {
                              if ((_imageMobileFileList != null &&
                                      _imageMobileFileList!.length > 0)) {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                _formKey.currentState!.save();
                                _uploadListing(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'At least one photo is required to create a listing. Please check listing and try again.')),
                                );
                                return;
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'A required field is missing. Please check listing and try again.')),
                              );
                            }
                          },
                          child: Text('Upload Listing'),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                    Container(
                      height: 20,
                    ),
                  ],
                ),
              ))));
    });
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
                      return Container();
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
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Container();
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

  showUploadingListingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialogWidget("Uploading Listing");
        });
  }

  showMatchingListingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialogWidget("Matching Listing");
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
                Navigator.popUntil(context, ModalRoute.withName('/'));
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

  Future<void> _showInstantNotifyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Instant Notify"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Get notified in real time when matching search posts are uploaded"),
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addressController.dispose();
    super.dispose();
  }
}

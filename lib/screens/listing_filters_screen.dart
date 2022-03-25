import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roomr/model/listing_filter_settings.dart';
import 'package:roomr/widgets/checkbox_widget.dart';
import 'package:roomr/widgets/price_range_widget.dart';

class ListingFiltersScreen extends StatefulWidget {
  ListingFiltersScreen();

  @override
  _ListingFiltersScreenState createState() => _ListingFiltersScreenState();
}

class _ListingFiltersScreenState extends State<ListingFiltersScreen> {
  bool byuApproved = false;
  bool hasAC = false;
  bool petsAllowed = false;
  bool hasPool = false;
  bool hasHotTub = false;
  bool hasGym = false;
  bool hasWifi = false;
  bool hasDishwasher = false;
  bool isFurnished = false;
  String roomType = 'Any Type';
  String contractType = 'Any Type';
  String parkingType = 'Any Type';
  String laundryType = 'Any Type';
  DateTime startAvailableDate = DateTime.now();
  DateTime endAvailableDate = DateTime.now();
  TextEditingController bedroomCountController = new TextEditingController();
  TextEditingController bathroomCountController = new TextEditingController();
  double lowerPrice = 0.0;
  double higherPrice = 3000.0;
  bool dataUpdated = false;
  bool anyDate = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ListingFilterSettings;
    _updateDetails(args);

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Listings',
            style: Theme.of(context).textTheme.headline6),
        leading: Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () {
                print('Canceling filter update');
                Navigator.pop(context, args);
              },
              child: Text("Cancel"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
                print('Saving filters');
                ListingFilterSettings? filters = ListingFilterSettings(
                  minPrice: lowerPrice.toInt(),
                  maxPrice: higherPrice.toInt(),
                  hasAirConditioning: hasAC,
                  petsAllowed: petsAllowed,
                  hasPool: hasPool,
                  hasHotTub: hasHotTub,
                  hasWifi: hasWifi,
                  hasDishwasher: hasDishwasher,
                  isFurnished: isFurnished,
                  laundryType: laundryType,
                  hasGym: hasGym,
                  roomType: roomType,
                  contractType: contractType,
                  parkingType: parkingType,
                  startAvailabilityDate: Timestamp.fromDate(startAvailableDate),
                  bedroomAmount: int.tryParse(bedroomCountController.text) ?? 1,
                  bathroomAmount:
                      int.tryParse(bathroomCountController.text) ?? 1,
                );
                Navigator.pop(context, filters);
              },
              child: Text("Save"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(
          //minHeight: 50.0,
          maxWidth: 500.0,
        ),
        child: ListView(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: PriceRangeWidget(
                  lowerVal: lowerPrice,
                  higherVal: higherPrice,
                  updateFunction: (value) {
                    setState(() {
                      this.lowerPrice = value.start;
                      this.higherPrice = value.end;
                    });
                  })),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 5,
            endIndent: 5,
          ),
          Center(
              child: Text(
            'Amenities & Features',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          /*CheckboxWidget(
              title: 'BYU Approved',
              updateFunction: (value){ setState(() {this.byuApproved = value;});},
              initialValue: this.byuApproved,
              ),*/
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Air Conditioning',
                updateFunction: (value) {
                  setState(() {
                    this.hasAC = value;
                  });
                },
                initialValue: this.hasAC,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Dishwasher',
                updateFunction: (value) {
                  setState(() {
                    this.hasDishwasher = value;
                  });
                },
                initialValue: this.hasDishwasher,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Furnished',
                updateFunction: (value) {
                  setState(() {
                    this.isFurnished = value;
                  });
                },
                initialValue: this.isFurnished,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Gym',
                updateFunction: (value) {
                  setState(() {
                    this.hasGym = value;
                  });
                },
                initialValue: this.hasGym,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Hot Tub',
                updateFunction: (value) {
                  setState(() {
                    this.hasHotTub = value;
                  });
                },
                initialValue: this.hasHotTub,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Pets Allowed',
                updateFunction: (value) {
                  setState(() {
                    this.petsAllowed = value;
                  });
                },
                initialValue: this.petsAllowed,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Pool',
                updateFunction: (value) {
                  setState(() {
                    this.hasPool = value;
                  });
                },
                initialValue: this.hasPool,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CheckboxWidget(
                title: 'Wifi',
                updateFunction: (value) {
                  setState(() {
                    this.hasPool = value;
                  });
                },
                initialValue: this.hasPool,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text('Contract Type: '),
                  DropdownButton<String>(
                    value: this.contractType,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        this.contractType = newValue!;
                      });
                    },
                    items: <String>[
                      'Any Type',
                      'Co-Ed',
                      'Male',
                      'Female',
                      'Family'
                    ].map<DropdownMenuItem<String>>((String value) {
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
                    value: this.laundryType,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        this.laundryType = newValue!;
                      });
                    },
                    items: <String>['Any Type', 'None', 'Shared', 'In Unit']
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
                  Text('Parking Type: '),
                  DropdownButton<String>(
                    value: this.parkingType,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        this.parkingType = newValue!;
                      });
                    },
                    items: <String>[
                      'Any Type',
                      'Street Parking',
                      'Garage Parking',
                      'Off-Street Parking',
                      'None'
                    ].map<DropdownMenuItem<String>>((String value) {
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
                    value: this.roomType,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        this.roomType = newValue!;
                      });
                    },
                    items: <String>[
                      'Any Type',
                      'Shared Room',
                      'Private Room',
                      'Entire Unit'
                    ].map<DropdownMenuItem<String>>((String value) {
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
          Row(
            children: [
              Padding(
                  child: Text('Listing Availability Range:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5)),
              if (anyDate == false)
                Padding(
                    child: Text(
                        DateFormat('MM-dd-yyyy').format(startAvailableDate)),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5)),
              if (anyDate == false)
                Padding(
                    child: Text(' to ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5)),
              if (anyDate == false)
                Padding(
                    child:
                        Text(DateFormat('MM-dd-yyyy').format(endAvailableDate)),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5)),
              if (anyDate == true)
                Padding(
                    child: Text(" Any Date"),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5)),
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
                  setState(() {
                    anyDate = true;
                    startAvailableDate = DateTime.now();
                    endAvailableDate = DateTime.now();
                  });
                },
                child: Text('Allow Any Date'),
              ),
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
          Padding(
              child: OutlinedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  debugPrint('Received change date click');
                  _selectStartDate(context);
                },
                child: Text('Change Start Date'),
              ),
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
          Padding(
              child: OutlinedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  debugPrint('Received change date click');
                  _selectEndDate(context);
                },
                child: Text('Change End Date'),
              ),
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 5,
            endIndent: 5,
          ),
          Center(
              child: Text(
            'Room Amounts',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount Of Bedrooms'),
                controller: bedroomCountController,
                keyboardType: TextInputType.number,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount Of Bathrooms'),
                controller: bathroomCountController,
                keyboardType: TextInputType.number,
              )),
        ]),
      )),
    );
  }

  void _updateDetails(ListingFilterSettings args) {
    if (dataUpdated == false) {
      this.hasAC = args.hasAirConditioning ?? false;
      this.petsAllowed = args.petsAllowed ?? false;
      this.hasDishwasher = args.hasDishwasher ?? false;
      this.hasWifi = args.hasWifi ?? false;
      this.isFurnished = args.isFurnished ?? false;
      this.hasPool = args.hasPool ?? false;
      this.hasHotTub = args.hasHotTub ?? false;
      this.hasGym = args.hasGym ?? false;
      this.roomType = args.roomType ?? 'Any Type';
      this.laundryType = args.laundryType ?? 'Any Type';
      this.contractType = args.contractType ?? 'Any Type';
      this.parkingType = args.parkingType ?? 'Any Type';
      this.startAvailableDate =
          args.startAvailabilityDate?.toDate() ?? DateTime.now();
      this.endAvailableDate =
          args.endAvailabilityDate?.toDate() ?? DateTime.now();
      if (args.bedroomAmount == null) {
        this.bedroomCountController.text = "";
      } else {
        this.bedroomCountController.text = args.bedroomAmount.toString();
      }

      if (args.bathroomAmount == null) {
        this.bathroomCountController.text = "";
      } else {
        this.bathroomCountController.text = args.bathroomAmount.toString();
      }

      this.lowerPrice = args.minPrice?.toDouble() ?? 0.0;
      this.higherPrice = args.maxPrice?.toDouble() ?? 3000.0;
      this.dataUpdated = true;
    }
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startAvailableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    );
    if (picked != null && picked != startAvailableDate)
      setState(() {
        startAvailableDate = picked;
        anyDate = false;
      });

    if (endAvailableDate.millisecondsSinceEpoch <
        startAvailableDate.millisecondsSinceEpoch) {
      setState(() {
        endAvailableDate = picked!;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endAvailableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    );
    if (picked != null && picked != endAvailableDate)
      setState(() {
        endAvailableDate = picked;
        anyDate = false;
      });

    if (endAvailableDate.millisecondsSinceEpoch <
        startAvailableDate.millisecondsSinceEpoch) {
      setState(() {
        startAvailableDate = picked!;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    bathroomCountController.dispose();
    bedroomCountController.dispose();
    super.dispose();
  }
}

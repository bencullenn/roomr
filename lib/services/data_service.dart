import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomr/model/account.dart';
import 'package:roomr/model/address.dart';
import 'package:roomr/model/geometry.dart';
import 'package:roomr/model/listing.dart';
import 'package:roomr/model/listing_filter_settings.dart';
import 'package:roomr/model/location.dart';
import 'package:roomr/model/place.dart';
import 'package:uuid/uuid.dart';

class DataService {
  var uuid = Uuid();

  /// Object References
  final listingRef =
      FirebaseFirestore.instance.collection('listings').withConverter<Listing>(
            fromFirestore: (snapshot, _) => Listing.fromJson(snapshot.data()!),
            toFirestore: (listing, _) => listing.toJson(),
          );

  final accountRef =
      FirebaseFirestore.instance.collection('accounts').withConverter<Account>(
            fromFirestore: (snapshot, _) => Account.fromJson(snapshot.data()!),
            toFirestore: (account, _) => account.toJson(),
          );

  ///Listing Functions
  Future<String> uploadListing({
    List<XFile>? imageMobileFileList,
    Place? place,
    String? incentive,
    String? roomType,
    String? description,
    Timestamp? dateAvailable,
    String? parkingType,
    String? contractType,
    String? rent,
    String? utilities,
    String? bedroomCount,
    String? bathroomCount,
    bool? petsAllowed,
    bool? hasGym,
    bool? hasPool,
    bool? hasHotTub,
    String? laundryType,
    bool? hasAC,
    bool? byuIdahoApproved,
    bool? byuHawaiiApproved,
    bool? byuProvoApproved,
    String? ownerUid,
    bool? instantNotify,
    bool? hasWifi,
    bool? hasDishwasher,
    bool? isFurnished,
  }) async {
    try {
      List<String> photoLinks;
      photoLinks = await uploadImageFiles(imageMobileFileList);
      print('Photo link length:' + photoLinks.length.toString());
      if (place != null) {
        final listingInfo = await listingRef.add(
          Listing(
              photos: photoLinks,
              formattedAddress: place.name,
              street:
                  place.address.streetNumber + ' ' + place.address.streetName,
              city: place.address.city,
              state: place.address.state,
              zipCode: place.address.zipCode,
              incentive: incentive ?? '',
              roomType: roomType ?? '',
              description: description ?? '',
              dateAvailable: dateAvailable ?? Timestamp.now(),
              parkingType: parkingType ?? '',
              contractType: contractType ?? '',
              rent: int.parse(rent ?? '0'),
              utilities: int.parse(utilities ?? '0'),
              bedroomCount: int.parse(bedroomCount ?? '0'),
              bathroomCount: int.parse(bathroomCount ?? '0'),
              petsAllowed: petsAllowed ?? false,
              hasGym: hasGym ?? false,
              hasPool: hasPool ?? false,
              hasHotTub: hasHotTub ?? false,
              byuIApproved: byuIdahoApproved ?? false,
              byuHApproved: byuHawaiiApproved ?? false,
              byuPApproved: byuProvoApproved ?? false,
              hasAC: hasAC ?? false,
              isPremiumListing: false,
              hasWifi: hasWifi ?? false,
              laundryType: laundryType ?? "None",
              hasDishwasher: hasDishwasher ?? false,
              isFurnished: isFurnished ?? false,
              dateLastModified: Timestamp.now(),
              createdDate: Timestamp.now(),
              ownerUid: ownerUid ?? '',
              attachedPosts: [],
              status: "Available",
              instantNotify: instantNotify ?? true),
        );
        return 'success';
      } else {
        print('Place was null. Could not create listing');
        return 'Place was null. Could not create listing';
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> updateListing(
      {Place? place,
      String? incentive,
      String? roomType,
      String? description,
      DateTime? dateAvailable,
      String? parkingType,
      String? contractType,
      String? rent,
      String? utilities,
      String? bedroomCount,
      String? bathroomCount,
      bool? petsAllowed,
      bool? hasGym,
      bool? hasPool,
      bool? hasHotTub,
      String? laundryType,
      bool? hasAC,
      bool? byuIdahoApproved,
      bool? byuHawaiiApproved,
      bool? byuProvoApproved,
      bool? hasWifi,
      bool? hasDishwasher,
      bool? isFurnished,
      bool? instantNotify,
      String? ownerUid,
      String? listingId,
      String? listingStatus,
      List<String>? oldPhotoLinks,
      List<XFile>? newMobilePhotoFiles,
      bool? changePhotos}) async {
    try {
      if (listingId != null) {
        if (oldPhotoLinks == null) {
          print("Old Photo Links were null");
          return "Old Photo Links were null";
        }
        //Upload new photos if change photos is true
        if (changePhotos ?? false) {
          print("Updating photos");
          List<String> newPhotoLinks;
          newPhotoLinks = await uploadImageFiles(newMobilePhotoFiles);
          print("New Photo links:" + newPhotoLinks.toString());
          if (place != null) {
            await listingRef.doc(listingId).update({
              "formattedAddress": place.name,
              "street":
                  place.address.streetNumber + ' ' + place.address.streetName,
              "city": place.address.city,
              "state": place.address.state,
              "zipCode": place.address.zipCode,
              "incentive": incentive ?? '',
              "roomType": roomType ?? '',
              "description": description ?? '',
              "dateAvailable": dateAvailable?.millisecondsSinceEpoch ??
                  Timestamp.now().millisecondsSinceEpoch,
              "parkingType": parkingType ?? '',
              "contractType": contractType ?? '',
              "rent": int.parse(rent ?? '0'),
              "utilities": int.parse(utilities ?? '0'),
              "bedroomCount": int.parse(bedroomCount ?? '0'),
              "bathroomCount": int.parse(bathroomCount ?? '0'),
              "petsAllowed": petsAllowed ?? false,
              "hasGym": hasGym ?? false,
              "hasPool": hasPool ?? false,
              "hasHotTub": hasHotTub ?? false,
              'byuIApproved': byuIdahoApproved ?? false,
              "byuHApproved": byuHawaiiApproved ?? false,
              "byuPApproved": byuProvoApproved ?? false,
              "hasWifi": hasWifi ?? false,
              "laundryType": laundryType ?? "None",
              "hasDishwasher": hasDishwasher ?? false,
              "isFurnished": isFurnished ?? false,
              "instantNotify": instantNotify ?? true,
              "isPremiumListing": false,
              "dateLastModified": Timestamp.now().millisecondsSinceEpoch,
              "status": listingStatus ?? '',
              "photos": newPhotoLinks
            });
            //Delete old photos
            for (String link in oldPhotoLinks) {
              await firebase_storage.FirebaseStorage.instance
                  .refFromURL(link)
                  .delete();
            }
          } else {
            await listingRef.doc(listingId).update({
              "incentive": incentive ?? '',
              "roomType": roomType ?? '',
              "description": description ?? '',
              "dateAvailable": dateAvailable?.millisecondsSinceEpoch ??
                  Timestamp.now().millisecondsSinceEpoch,
              "parkingType": parkingType ?? '',
              "contractType": contractType ?? '',
              "rent": int.parse(rent ?? '0'),
              "utilities": int.parse(utilities ?? '0'),
              "bedroomCount": int.parse(bedroomCount ?? '0'),
              "bathroomCount": int.parse(bathroomCount ?? '0'),
              "petsAllowed": petsAllowed ?? false,
              "hasGym": hasGym ?? false,
              "hasPool": hasPool ?? false,
              "hasHotTub": hasHotTub ?? false,
              "hasWifi": hasWifi ?? false,
              "laundryType": laundryType ?? "None",
              "hasDishwasher": hasDishwasher ?? false,
              "isFurnished": isFurnished ?? false,
              "instantNotify": instantNotify ?? false,
              'byuIApproved': byuIdahoApproved ?? false,
              "byuHApproved": byuHawaiiApproved ?? false,
              "byuPApproved": byuProvoApproved ?? false,
              "hasAC": hasAC ?? false,
              "isPremiumListing": false,
              "dateLastModified": Timestamp.now().millisecondsSinceEpoch,
              "status": listingStatus ?? '',
              "photos": newPhotoLinks
            });
            //Delete old photos
            for (String link in oldPhotoLinks) {
              await firebase_storage.FirebaseStorage.instance
                  .refFromURL(link)
                  .delete();
            }
          }
        } else {
          // Photos don't need to be changed
          if (place != null) {
            await listingRef.doc(listingId).update({
              "formattedAddress": place.name,
              "street":
                  place.address.streetNumber + ' ' + place.address.streetName,
              "city": place.address.city,
              "state": place.address.state,
              "zipCode": place.address.zipCode,
              "incentive": incentive ?? '',
              "roomType": roomType ?? '',
              "description": description ?? '',
              "dateAvailable": dateAvailable?.millisecondsSinceEpoch ??
                  Timestamp.now().millisecondsSinceEpoch,
              "parkingType": parkingType ?? '',
              "contractType": contractType ?? '',
              "rent": int.parse(rent ?? '0'),
              "utilities": int.parse(utilities ?? '0'),
              "bedroomCount": int.parse(bedroomCount ?? '0'),
              "bathroomCount": int.parse(bathroomCount ?? '0'),
              "petsAllowed": petsAllowed ?? false,
              "hasGym": hasGym ?? false,
              "hasPool": hasPool ?? false,
              "hasHotTub": hasHotTub ?? false,
              "hasWifi": hasWifi ?? false,
              "laundryType": laundryType ?? "None",
              "hasDishwasher": hasDishwasher ?? false,
              "isFurnished": isFurnished ?? false,
              "instantNotify": instantNotify ?? false,
              'byuIApproved': byuIdahoApproved ?? false,
              "byuHApproved": byuHawaiiApproved ?? false,
              "byuPApproved": byuProvoApproved ?? false,
              "hasAC": hasAC ?? false,
              "isPremiumListing": false,
              "dateLastModified": Timestamp.now().millisecondsSinceEpoch,
              "status": listingStatus ?? '',
            });
          } else {
            await listingRef.doc(listingId).update({
              "incentive": incentive ?? '',
              "roomType": roomType ?? '',
              "description": description ?? '',
              "dateAvailable": dateAvailable?.millisecondsSinceEpoch ??
                  Timestamp.now().millisecondsSinceEpoch,
              "parkingType": parkingType ?? '',
              "contractType": contractType ?? '',
              "rent": int.parse(rent ?? '0'),
              "utilities": int.parse(utilities ?? '0'),
              "bedroomCount": int.parse(bedroomCount ?? '0'),
              "bathroomCount": int.parse(bathroomCount ?? '0'),
              "petsAllowed": petsAllowed ?? false,
              "hasGym": hasGym ?? false,
              "hasPool": hasPool ?? false,
              "hasHotTub": hasHotTub ?? false,
              "hasWifi": hasWifi ?? false,
              "laundryType": laundryType ?? "None",
              "hasDishwasher": hasDishwasher ?? false,
              "isFurnished": isFurnished ?? false,
              "instantNotify": instantNotify ?? false,
              'byuIApproved': byuIdahoApproved ?? false,
              "byuHApproved": byuHawaiiApproved ?? false,
              "byuPApproved": byuProvoApproved ?? false,
              "hasAC": hasAC ?? false,
              "isPremiumListing": false,
              "dateLastModified": Timestamp.now().millisecondsSinceEpoch,
              "status": listingStatus ?? '',
            });
          }
        }
        return 'success';
      } else {
        print("Listing Id was null so listing could not be updated");
        return "Listing Id was null so listing could not be updated";
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<List<String>> uploadImageFiles(List<XFile>? imageFiles) async {
    List<String> fileLinks = [];
    if (imageFiles == null) {
      print("Images files array was null. Adding default image.");
      fileLinks.add("");
      return fileLinks;
    }

    for (var file in imageFiles) {
      final name = 'listings-photos/' + uuid.v1() + '.png';
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(name)
            .putFile(File(file.path));
      } on firebase_core.FirebaseException catch (e) {
        print('Error:' + e.code);
      }
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(name)
          .getDownloadURL();
      fileLinks.add(url);
    }

    print('Photos uploaded');
    return fileLinks;
  }

  Future<List<QueryDocumentSnapshot<Listing>>> getListings(
      {ListingFilterSettings? filters, Place? location}) async {
    print('Getting Listings');
    List<QueryDocumentSnapshot<Listing>> filteredListings = [];

    print('Filters:' + filters.toString());
    print('Location:' + location.toString());

    bool filterFieldsNull = false;

    if (filters != null &&
        filters.maxPrice == null &&
        filters.minPrice == null &&
        filters.contractType == null &&
        filters.roomType == null &&
        filters.contractType == null &&
        filters.parkingType == null &&
        filters.petsAllowed == null &&
        filters.anyDate == null &&
        filters.hasPool == null &&
        filters.hasDishwasher == null &&
        filters.hasWifi == null &&
        filters.isFurnished == null &&
        filters.laundryType == null &&
        filters.hasHotTub == null &&
        filters.hasAirConditioning == null &&
        filters.hasGym == null &&
        filters.bedroomAmount == null &&
        filters.bathroomAmount == null) {
      filterFieldsNull = true;
    }

    if (filters == null || filterFieldsNull) {
      if (location == null) {
        filteredListings = await this
            .listingRef
            .orderBy('createdDate', descending: true)
            .get()
            .then((snapshot) => snapshot.docs);
      } else {
        filteredListings = await this
            .listingRef
            .where('city', isEqualTo: location.address.city)
            .where('state', isEqualTo: location.address.state)
            .orderBy('createdDate', descending: true)
            .get()
            .then((snapshot) => snapshot.docs);
      }
    } else {
      List<QueryDocumentSnapshot<Listing>> listingDocs = [];
      listingDocs = await this
          .listingRef
          .orderBy('createdDate', descending: true)
          .get()
          .then((snapshot) => snapshot.docs);
      List<String> contractTypes = [];
      List<String> parkingTypes = [];
      List<String> roomTypes = [];
      List<String> laundryTypes = [];

      if (filters.contractType == 'Any Type' || filters.contractType == null) {
        contractTypes = ['Co-Ed', 'Male', 'Female', 'Family'];
      } else {
        contractTypes.add(filters.contractType!);
      }

      if (filters.parkingType == 'Any Type' || filters.parkingType == null) {
        parkingTypes = [
          'Street Parking',
          'Garage Parking',
          'Off-Street Parking',
          'None'
        ];
      } else {
        parkingTypes.add(filters.parkingType!);
      }

      if (filters.roomType == 'Any Type' || filters.roomType == null) {
        roomTypes = ['Shared Room', 'Private Room', 'Entire Unit'];
      } else {
        roomTypes.add(filters.roomType!);
      }

      if (filters.laundryType == 'Any Type' || filters.laundryType == null) {
        laundryTypes = ['None', 'Shared', 'In Unit'];
      } else {
        laundryTypes.add(filters.laundryType!);
      }

      int bedroomCount = 1;
      int bathroomCount = 1;
      if (filters.bedroomAmount != null) {
        bedroomCount = filters.bedroomAmount!;
      }

      if (filters.bathroomAmount != null) {
        bathroomCount = filters.bathroomAmount!;
      }

      int minPrice = filters.minPrice ?? 0;
      int maxPrice = filters.maxPrice ?? 10000;
      print('Min Price:' + minPrice.toString());
      print('Max Price:' + maxPrice.toString());
      print('Room Type:' + roomTypes.toString());
      print('Parking Type:' + parkingTypes.toString());
      print('Contact Type:' + contractTypes.toString());
      print('Bathroom Count:' + bathroomCount.toString());
      print('Bedroom Count:' + bedroomCount.toString());

      //Check if any listing amenities types are null
      if (filters.hasAirConditioning == null ||
          filters.hasGym == null ||
          filters.hasHotTub == null ||
          filters.isFurnished == null ||
          filters.hasWifi == null ||
          filters.hasDishwasher == null ||
          filters.hasPool == null ||
          filters.petsAllowed == null) {
        filters.amenitiesFiltersDisabled = true;
      }

      //Check if they are all false
      if (filters.hasAirConditioning == false &&
          filters.hasGym == false &&
          filters.hasHotTub == false &&
          filters.isFurnished == false &&
          filters.hasWifi == false &&
          filters.hasDishwasher == false &&
          filters.hasPool == false &&
          filters.petsAllowed == false) {
        filters.amenitiesFiltersDisabled = true;
      }

      print(
          "Amentites disabled:" + filters.amenitiesFiltersDisabled.toString());

      if (location == null) {
        //No location specified
        if (filters.amenitiesFiltersDisabled) {
          print('Amenities filters disabled case');
          listingDocs = await this
              .listingRef
              .where('rent', isGreaterThan: minPrice)
              .where('rent', isLessThan: maxPrice)
              .where('contractType', whereIn: contractTypes)
              .where('bedroomCount', isEqualTo: bedroomCount)
              .where('bathroomCount', isEqualTo: bathroomCount)
              .get()
              .then((snapshot) => snapshot.docs);
        } else {
          print('Filter by Amenities case');
          listingDocs = await this
              .listingRef
              .where('rent', isGreaterThan: filters.minPrice ?? 0.0)
              .where('rent', isLessThan: filters.maxPrice ?? 10000.00)
              .where('contractType', whereIn: contractTypes)
              .where('bedroomCount', isEqualTo: bedroomCount)
              .where('bathroomCount', isEqualTo: bathroomCount)
              .where('hasAC', isEqualTo: filters.hasAirConditioning ?? false)
              .where('hasGym', isEqualTo: filters.hasGym ?? false)
              .where('hasHotTub', isEqualTo: filters.hasHotTub ?? false)
              .where('hasWifi', isEqualTo: filters.hasWifi ?? false)
              .where('isFurnished', isEqualTo: filters.isFurnished ?? false)
              .where('hasDishwasher', isEqualTo: filters.hasDishwasher ?? false)
              .where('hasPool', isEqualTo: filters.hasPool ?? false)
              .where('petsAllowed', isEqualTo: filters.petsAllowed ?? false)
              .get()
              .then((snapshot) => snapshot.docs);
        }
      } else {
        // Location specified
        if (filters.amenitiesFiltersDisabled) {
          print('Amenities filters disabled case');
          print("City:" + location.address.city);
          print("State:" + location.address.state);

          listingDocs = await this
              .listingRef
              .where('city', isEqualTo: location.address.city)
              .where('state', isEqualTo: location.address.state)
              .where('rent', isGreaterThan: filters.minPrice ?? 0.0)
              .where('rent', isLessThan: filters.maxPrice ?? 10000.0)
              .where('contractType', whereIn: contractTypes)
              .where('bedroomCount', isEqualTo: bedroomCount)
              .where('bathroomCount', isEqualTo: bathroomCount)
              .get()
              .then((snapshot) => snapshot.docs);
        } else {
          print("City:" + location.address.city);
          print("State:" + location.address.state);
          print('Filter by Amenities case');
          listingDocs = await this
              .listingRef
              .where('city', isEqualTo: location.address.city)
              .where('state', isEqualTo: location.address.state)
              .where('rent', isGreaterThan: filters.minPrice ?? 0.0)
              .where('rent', isLessThan: filters.maxPrice ?? 10000.0)
              .where('contractType', whereIn: contractTypes)
              .where('bedroomCount', isEqualTo: bedroomCount)
              .where('bathroomCount', isEqualTo: bathroomCount)
              .where('hasAC', isEqualTo: filters.hasAirConditioning ?? false)
              .where('hasGym', isEqualTo: filters.hasGym ?? false)
              .where('hasHotTub', isEqualTo: filters.hasHotTub ?? false)
              .where('hasWifi', isEqualTo: filters.hasWifi ?? false)
              .where('isFurnished', isEqualTo: filters.isFurnished ?? false)
              .where('hasDishwasher', isEqualTo: filters.hasDishwasher ?? false)
              .where('hasPool', isEqualTo: filters.hasPool ?? false)
              .where('petsAllowed', isEqualTo: filters.petsAllowed ?? false)
              .get()
              .then((snapshot) => snapshot.docs);
        }
      }

      print('Listing docs length:' + listingDocs.length.toString());

      //filter by parking, room type, and availability date on device
      for (QueryDocumentSnapshot<Listing> listing in listingDocs) {
        print(listing.data().toJson());
        if (parkingTypes.contains(listing.data().parkingType) &&
            roomTypes.contains(listing.data().roomType) &&
            laundryTypes.contains(listing.data().laundryType)) {
          if (filters.startAvailabilityDate != null &&
              filters.endAvailabilityDate != null &&
              filters.anyDate == false) {
            if (listing.data().dateAvailable.millisecondsSinceEpoch <=
                filters.endAvailabilityDate!.millisecondsSinceEpoch) {
              filteredListings.add(listing);
            }
          } else {
            filteredListings.add(listing);
          }
        }
      }
    }

    print('Listing list size:' + filteredListings.length.toString());
    for (QueryDocumentSnapshot<Listing> listing in filteredListings) {
      print(listing.data().toJson());
    }
    return filteredListings;
  }

  Future<List<QueryDocumentSnapshot<Listing>>> getFeaturedListings() async {
    return await this
        .listingRef
        .orderBy('createdDate', descending: true)
        .get()
        .then((snapshot) => snapshot.docs);
  }

  Future<List<QueryDocumentSnapshot<Listing>>> getListingsForUserId(
      {String userId = ''}) async {
    print('Getting Listings for ownerId:' + userId);
    List<QueryDocumentSnapshot<Listing>> listingDocs = await this
        .listingRef
        .where('ownerUid', isEqualTo: userId)
        .orderBy('createdDate', descending: true)
        .get()
        .then((snapshot) => snapshot.docs);

    print('Listing list size:' + listingDocs.length.toString());
    for (QueryDocumentSnapshot<Listing> listing in listingDocs) {
      print(listing.data().toJson());
    }
    return listingDocs;
  }

  Future<DocumentSnapshot<Listing>> getListingForId(
      {required String listingID}) async {
    print('Getting Listing for Id:' + listingID);
    DocumentSnapshot<Listing> listing =
        await this.listingRef.doc(listingID).get();

    return listing;
  }

  Future<String> deleteListingWithID(
      String listingID, List<String> imageLinks) async {
    String result = "";
    try {
      for (String link in imageLinks) {
        await firebase_storage.FirebaseStorage.instance
            .refFromURL(link)
            .delete();
      }

      await listingRef
          .doc(listingID)
          .delete()
          .then((value) => result = "success")
          .catchError((error) => result = error.toString());

      print("Delete Listing Result:" + result);
    } catch (e) {
      print(e.toString());
      result = e.toString();
    }

    return result;
  }

  /// Account Functions
  Future<String> createAccount(
      {String? firstName,
      String? lastName,
      String? email,
      String? uuid,
      String? mobileNumber,
      String? prefContactMethod,
      String? referMethod,
      String? otherReferMethodDescription}) async {
    try {
      print("Getting notification token");
      //Get Notification tokens

      await accountRef.add(
        Account(
            firstName: firstName ?? '',
            lastName: lastName ?? '',
            email: email ?? '',
            uuid: uuid ?? '',
            mobileNumber: mobileNumber ?? '',
            prefContactMethod: prefContactMethod ?? '',
            referMethod: referMethod ?? '',
            otherReferMethodDescription: otherReferMethodDescription ?? ''),
      );
      print('Account created');
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> uploadAccount(Account account) async {
    try {
      print("Adding account");
      await accountRef.add(account);
      print('Account Uploaded');
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> updateAccount(
      {String? userID,
      String? firstName,
      String? lastName,
      String? email,
      String? mobileNumber,
      String? prefContactMethod,
      List<String>? notificationTokens}) async {
    try {
      if (userID != null) {
        String accountID = await getAccountIdForUserId(userID);
        if (accountID != "") {
          await accountRef.doc(accountID).update({
            'firstName': firstName ?? '',
            'lastName': lastName ?? '',
            'email': email ?? '',
            'mobileNumber': mobileNumber ?? '',
            'prefContactMethod': prefContactMethod ?? '',
            'notificationTokens': notificationTokens ?? []
          });
          print('Account updated');
          return 'success';
        } else {
          print('Account could not be updated because the user Id was null');
          return 'Account could not be updated because the user Id was invalid';
        }
      }
    } catch (error) {
      return error.toString();
    }
    return "";
  }

  Future<String> getAccountIdForUserId(String userId) async {
    print('Getting Account For User ID:' + userId);
    List<QueryDocumentSnapshot<Account>> accountDocs = await this
        .accountRef
        .where('uuid', isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs);
    print('Listing list size:' + accountDocs.length.toString());

    if (accountDocs.length == 0) {
      print('No existing account for User Id. Returning Null');
      return '';
    } else if (accountDocs.length == 1) {
      print('Account found for user Id');
      return accountDocs[0].id;
    } else if (accountDocs.length > 1) {
      print('Found multiple accounts for user Id. Returning first instance.');
      return accountDocs[0].id;
    } else {
      return "";
    }
  }

  Future<Account?> getAccountForUserId(String userId) async {
    print('Getting Account For User ID:' + userId);
    List<QueryDocumentSnapshot<Account>> accountDocs = await this
        .accountRef
        .where('uuid', isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs);
    print('Listing list size:' + accountDocs.length.toString());

    if (accountDocs.length == 0) {
      print('No existing account for User Id. Returning Null');
      return null;
    } else if (accountDocs.length == 1) {
      print('Account found for user Id');
      print(accountDocs[0]);
      return Account.fromJson(accountDocs[0].data().toJson());
    } else if (accountDocs.length > 1) {
      print('Found multiple accounts for user Id. Returning first instance.');
      return Account.fromJson(accountDocs[0].data().toJson());
    }
  }
}

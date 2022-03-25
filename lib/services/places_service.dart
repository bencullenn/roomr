import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:roomr/model/place.dart';
import 'dart:convert' as convert;

import 'package:roomr/model/place_search.dart';

class PlacesService {
  var key = 'YOUR API KEY HERE';

  Future<List<PlaceSearch>?> getCityAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(Uri.parse(url));
    print("Get City Response:");
    print(response.toString());
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<List<PlaceSearch>?> getAddressAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=address&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place?> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    print('JSON:');
    print(json);
    return Place.fromJson(jsonResult);
  }
}

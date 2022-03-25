import 'package:roomr/model/address.dart';
import 'package:roomr/model/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String vicinity;
  final Address address;

  Place(
      {required this.geometry,
      required this.name,
      required this.vicinity,
      required this.address});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
        geometry: Geometry.fromJson(parsedJson['geometry']),
        name: parsedJson['formatted_address'],
        vicinity: parsedJson['vicinity'],
        address: Address.fromJson(parsedJson['address_components']));
  }

  @override
  String toString() {
    return 'Place{geometry: $geometry, name: $name, vicinity: $vicinity, address: $address}';
  }
}

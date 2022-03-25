// Doesn't use JSON_Annotation library because of custom creation code
class Address {
  String streetNumber = '';
  String streetName = '';
  String city = '';
  String state = '';
  String zipCode = '';

  Address();

  factory Address.fromJson(List<dynamic> parsedJson) {
    Address address = new Address();
    for (int i = 0; i < parsedJson.length; i++) {
      Map<String, dynamic> data = parsedJson[i] as Map<String, dynamic>;

      if (data['types'].contains("street_number")) {
        address.streetNumber = data['long_name'] as String;
      } else if (data['types'].contains("route")) {
        address.streetName = data['long_name'] as String;
      } else if (data['types'].contains("locality")) {
        address.city = data['long_name'] as String;
      } else if (data['types'].contains("administrative_area_level_1")) {
        address.state = data['long_name'] as String;
      } else if (data['types'].contains("postal_code")) {
        address.zipCode = data['long_name'] as String;
      }
    }

    return address;
  }

  @override
  String toString() =>
      'Address { Street Number: $streetNumber, Street Name: $streetName, '
      'City: $city, State: $state, ZipCode: $zipCode}';
}

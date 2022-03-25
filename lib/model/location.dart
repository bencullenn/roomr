import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

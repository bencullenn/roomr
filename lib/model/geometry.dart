import 'package:json_annotation/json_annotation.dart';
import 'package:roomr/model/location.dart';

part 'geometry.g.dart';

@JsonSerializable(includeIfNull: true)
class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson( Map<String, dynamic> json ) => _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}
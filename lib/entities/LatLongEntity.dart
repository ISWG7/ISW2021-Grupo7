
import 'package:json_annotation/json_annotation.dart';

part 'LatLongEntity.g.dart';

@JsonSerializable()
class LatLongEntity {
  double lat;
  double long;

  LatLongEntity(this.lat, this.long);

  factory LatLongEntity.fromJson(Map<String, dynamic> data) =>
      _$LatLongEntityFromJson(data);

  Map<String, dynamic> toJson() => _$LatLongEntityToJson(this);

}
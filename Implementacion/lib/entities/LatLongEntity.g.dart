// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LatLongEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLongEntity _$LatLongEntityFromJson(Map<String, dynamic> json) {
  return LatLongEntity(
    (json['lat'] as num).toDouble(),
    (json['long'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LatLongEntityToJson(LatLongEntity instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

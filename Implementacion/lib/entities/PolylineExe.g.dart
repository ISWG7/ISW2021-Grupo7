// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PolylineExe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolylineExe _$PolylineExeFromJson(Map<String, dynamic> json) {
  return PolylineExe(
    (json['coordinates'] as List<dynamic>)
        .map((e) =>
            (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
        .toList(),
    json['type'] as String,
  );
}

Map<String, dynamic> _$PolylineExeToJson(PolylineExe instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'type': instance.type,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DireccionEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DireccionEntity _$DireccionEntityFromJson(Map<String, dynamic> json) {
  return DireccionEntity(
    json['ciudad'] as String,
    json['calle'] as String,
    json['numeracion'] as int,
    json['referencia'] as String?,
  );
}

Map<String, dynamic> _$DireccionEntityToJson(DireccionEntity instance) =>
    <String, dynamic>{
      'ciudad': instance.ciudad,
      'calle': instance.calle,
      'numeracion': instance.numeracion,
      'referencia': instance.referencia,
    };

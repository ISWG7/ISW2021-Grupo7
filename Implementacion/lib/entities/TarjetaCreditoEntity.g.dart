// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TarjetaCreditoEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TarjetaCreditoEntity _$TarjetaCreditoEntityFromJson(Map<String, dynamic> json) {
  return TarjetaCreditoEntity(
    json['numero'] as String,
    json['expiracion'] as String,
    json['nombre'] as String,
    json['cvv'] as String,
  );
}

Map<String, dynamic> _$TarjetaCreditoEntityToJson(
        TarjetaCreditoEntity instance) =>
    <String, dynamic>{
      'numero': instance.numero,
      'expiracion': instance.expiracion,
      'nombre': instance.nombre,
      'cvv': instance.cvv,
    };

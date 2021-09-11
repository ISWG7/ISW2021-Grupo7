

import 'package:json_annotation/json_annotation.dart';

part 'DireccionEntity.g.dart';

@JsonSerializable(

)
class DireccionEntity {
  String ciudad ;
  String calle ;
  int numeracion;
  String? referencia;
  DireccionEntity(this.ciudad, this.calle, this.numeracion,
      this.referencia);

  factory DireccionEntity.fromJson(Map<String,dynamic> data) => _$DireccionEntityFromJson(data);

  Map<String,dynamic> toJson() => _$DireccionEntityToJson(this);
}

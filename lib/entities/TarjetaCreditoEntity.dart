
import 'package:json_annotation/json_annotation.dart';

part 'TarjetaCreditoEntity.g.dart';

@JsonSerializable()
class TarjetaCreditoEntity {
  String numero;
  String expiracion;
  String nombre;
  String cvv;

  TarjetaCreditoEntity(this.numero, this.expiracion, this.nombre, this.cvv);

  factory TarjetaCreditoEntity.fromJson(Map<String, dynamic> data) =>
      _$TarjetaCreditoEntityFromJson(data);

  Map<String, dynamic> toJson() => _$TarjetaCreditoEntityToJson(this);

}

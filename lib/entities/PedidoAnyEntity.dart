
 import 'package:json_annotation/json_annotation.dart';

part 'PedidoAnyEntity.g.dart';
@JsonSerializable(explicitToJson: true)

class PedidoAnyEntity {
  String? descripcion;
  String? pathImagen;

  PedidoAnyEntity({this.descripcion , this.pathImagen});

  factory PedidoAnyEntity.fromJson(Map<String,dynamic> data) => _$PedidoAnyEntityFromJson(data);

  Map<String,dynamic> toJson() => _$PedidoAnyEntityToJson(this);

}
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tp_isw/entities/DireccionEntity.dart';

import 'TarjetaCreditoEntity.dart';

part 'PedidoAnyEntity.g.dart';

@JsonSerializable(explicitToJson: true)
class PedidoAnyEntity {
  String? descripcion;
  String? pathImagen;
  DireccionEntity? entrega;
  DireccionEntity? retiro;
  String? medioPago;
  double? pagoEfectivo;
  TarjetaCreditoEntity? tarjeta;
  bool? entregaProgramada;
  String? fechaEntrega;
  String? horarioEntrega;

  PedidoAnyEntity(
      {this.descripcion,
      this.pathImagen,
      this.entrega,
      this.retiro,
      this.medioPago,
      this.pagoEfectivo,
      this.tarjeta,
      this.entregaProgramada,
      this.fechaEntrega,
      this.horarioEntrega});

  factory PedidoAnyEntity.fromJson(Map<String, dynamic> data) =>
      _$PedidoAnyEntityFromJson(data);

  Map<String, dynamic> toJson() => _$PedidoAnyEntityToJson(this);
}

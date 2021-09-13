import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tp_isw/entities/LatLongEntity.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';

import 'ZoomButtonsPlugin.dart';

class Map extends StatefulWidget {
  PedidoAnyController controller;
  PedidoAnyEntity entity;

  Map({required this.controller, required this.entity});

  @override
  State<StatefulWidget> createState() {
    return MapState();
  }
}

class MapState extends State<Map> {
  // posicion 0 para retiro , 1 para entrega
  HashMap<String, Marker> markers = HashMap();
  bool entregaBtnPressed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.validate = validate;
    widget.controller.save = save;

    initMarkers();
  }

  @override
  Widget build(BuildContext context) {
    final Widget entregaBtn = ElevatedButton.icon(
        label: Text("Entrega"),
        icon: Icon(Icons.home),
        style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
        onPressed: _entregaPressed);
    final Widget retiroBtn = ElevatedButton.icon(
      icon: Icon(Icons.delivery_dining),
      label: Text("Retiro"),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurpleAccent,
      ),
      onPressed: _retiroPressed,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Selecciona los puntos de entrega en el mapa'),
              entregaBtn,
              retiroBtn,
            ],
          ),
        ),
        Flexible(
          child: FlutterMap(
            options: MapOptions(
                center: LatLng(-31.4135, -64.18105),
                zoom: 13.0,
                plugins: [
                  ZoomButtonsPlugin(),
                ],
                onTap: _handleTap),
            layers: [
              TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayerOptions(markers: markers.values.toList()),
              PolylineLayerOptions(polylines: [
                // TODO AGRGAR AQUI LAS RUTAS
              ]),
            ],
            nonRotatedLayers: [
              ZoomButtonsPluginOption(
                minZoom: 4,
                maxZoom: 19,
                mini: true,
                padding: 10,
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleTap(LatLng latlng) {
    var icon =
        (entregaBtnPressed) ? Icon(Icons.home) : Icon(Icons.delivery_dining);

    Marker newMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: latlng,
      builder: (ctx) => Container(
        child: icon,
      ),
    );

    (entregaBtnPressed)
        ? setState(() {
            markers["Entrega"] = newMarker;
          })
        : setState(() {
            markers["Retiro"] = newMarker;
          });
  }

  void _entregaPressed() {
    setState(() {
      entregaBtnPressed = true;
    });
  }

  void _retiroPressed() {
    setState(() {
      entregaBtnPressed = false;
    });
  }

  bool validate() {
    // como es opcional siempre retornamos true
    return true;
  }

  void save() {
    if (markers["Entrega"] != null) {
      widget.entity.entregaLatLong = LatLongEntity(
          markers["Entrega"]!.point.latitude,
          markers["Entrega"]!.point.longitude);
    }
    if (markers["Retiro"] != null) {
      widget.entity.retiroLatLong = LatLongEntity(
          markers["Retiro"]!.point.latitude,
          markers["Retiro"]!.point.longitude);
    }
  }

  void initMarkers() {
    var entregaLatLong = widget.entity.entregaLatLong;
    if (entregaLatLong != null) {
      markers["Entrega"] = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(entregaLatLong.lat, entregaLatLong.long),
        builder: (ctx) => Container(
          child: Icon(Icons.home),
        ),
      );
    }
    var retiroLatLong = widget.entity.retiroLatLong;
    if (retiroLatLong != null) {
      markers["Retiro"] = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(retiroLatLong.lat, retiroLatLong.long),
        builder: (ctx) => Container(
          child: Icon(Icons.delivery_dining),
        ),
      );
    }
  }
}

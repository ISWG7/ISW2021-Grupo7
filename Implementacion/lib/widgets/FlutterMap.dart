import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_api/mapbox_api.dart';
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
  // TODO mover esto a un enum
  // [Entrega] y [Retiro]
  HashMap<String, Marker> markers = HashMap();
  bool entregaBtnPressed = true;
  List<LatLng> route =[];
  double distanciaTotal = 0;

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
              Text("Distancia Total $distanciaTotal metros")
            ],
          ),
        ),
        Flexible(
          child: FlutterMap(
            options: MapOptions(
                center: LatLng(-31.4135, -64.18105),
                zoom: 12.0,
                plugins: [
                  ZoomButtonsPlugin(),
                ],
                onTap: _handleTap),
            layers: [
              TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                    points: route,
                    strokeWidth: 4.0,
                    color: Colors.purple,
                  ),
                ],
              ),
              MarkerLayerOptions(markers: markers.values.toList()),
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

    //Despues de hacer click en el mapa , trato de dibujar la ruta
    calcularRuta();
  }

  void _entregaPressed() {
    setState(() {
      entregaBtnPressed = true;
    });
  }

  Future<void> calcularRuta() async {

    // si falta algun marcador no hacer nada
    if (!markers.containsKey("Entrega") || !markers.containsKey("Retiro")) {
      return;
    }

    final mapbox = MapboxApi(
      accessToken:
          'pk.eyJ1IjoiZXhlc2FsaW5hcyIsImEiOiJja3RqYnI2emcxYWszMnZxamc2d2QxMXoyIn0.oeISkE7ZpPSoWciocmOcMQ',
    );
    final response = await mapbox.directions.request(
      // TODO REVISAR DRIVIN G NOORMAL O TRAFIC
      profile: NavigationProfile.DRIVING_TRAFFIC,
      overview: NavigationOverview.FULL,
      geometries: NavigationGeometries.POLYLINE,
      steps: true,
      coordinates: <List<double>>[
        <double>[
          markers["Entrega"]!.point.latitude,
          markers["Entrega"]!.point.longitude
        ],
        <double>[
          markers["Retiro"]!.point.latitude,
          markers["Retiro"]!.point.longitude
        ],
      ],
    );
    final route = response.routes![0];
    final result = decodePolyline(route.geometry);
    final cords = result
        .map((par) => LatLng(par[0].toDouble(), par[1].toDouble()))
        .toList();


    // seteamos la ruta y la distancia total
    this.setState(() {
      this.distanciaTotal = route.distance??0;
      this.route = cords;
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


      calcularRuta();
    }
  }
}

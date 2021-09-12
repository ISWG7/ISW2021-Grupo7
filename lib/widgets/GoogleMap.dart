// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// import 'dart:ui' as ui;
//
// class GoogleMap extends StatefulWidget {
//   const GoogleMap({Key? key}) : super(key: key);
//
//   @override
//   _GoogleMapState createState() => _GoogleMapState();
// }
//
// class _GoogleMapState extends State<GoogleMap> {
//   @override
//   Widget build(BuildContext context) {
//     return getMap();
//   }

  // Widget getMap() {
  //   //A unique id to name the div element
  //   String htmlId = "6";
  //   //creates a webview in dart
  //   //ignore: undefined_prefixed_name
  //
  //   ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
  //     final latLang = LatLng(12.9007616, 77.6568832);
  //     //class to create a div element
  //
  //     final mapOptions = MapOptions()
  //       ..zoom = 11
  //       ..tilt = 90
  //       ..center = latLang;
  //     final elem = DivElement()
  //       ..id = htmlId
  //       ..style.width = "100%"
  //       ..style.height = "100%"
  //       ..style.border = "none";
  //
  //     final map = GMap(elem, mapOptions);
  //     Marker(MarkerOptions()
  //       ..position = latLang
  //       ..map = map
  //       ..title = 'My position');
  //     Marker(MarkerOptions()
  //       ..position = LatLng(12.9557616, 77.7568832)
  //       ..map = map
  //       ..title = 'My position');
  //     return elem;
  //   });
  //
  //   return HtmlElementView(
  //     viewType: htmlId,
  //   );
  // }
// }

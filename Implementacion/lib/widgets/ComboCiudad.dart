import 'package:flutter/material.dart';

class CiudadCombo extends StatelessWidget {
  final Function onChange;
  final String dropdownValue;

  const CiudadCombo(
      {Key? key, required this.onChange, required this.dropdownValue})
      : super(key: key);

  static const List<String> ciudades = [
    "Cordoba",
    "Buenos Aires",
    "Jujuy",
    "Mendoza"
  ];

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> items = [];

    ciudades.forEach((String value) {
      items.add(DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ));
    });

    return DropdownButton<String>(
        items: items,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          onChange.call(newValue);
        });
  }
}

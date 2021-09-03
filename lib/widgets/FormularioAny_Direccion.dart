import 'package:flutter/material.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/widgets/ComboCiudad.dart';

class FormularioAnythingDireccion extends StatelessWidget {
  PedidoAnyEntity entityModel;
  GlobalKey<FormState> formkey;

  var ciudad = "Cordoba";

  FormularioAnythingDireccion(
      {required this.entityModel, required this.formkey});

  final TextEditingController _referenciaController = TextEditingController();
  final TextEditingController _calleController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    Widget referencia = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: _referenciaController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Casa de 2 pisos roja',
          labelText: 'Referencia - Opcional'),
    );

    Widget calle = TextFormField(
      keyboardType: TextInputType.streetAddress,
      controller: _calleController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Av. 19 de Abril',
          labelText: 'Calle * '),
    );

    Widget numero = TextFormField(
      keyboardType: TextInputType.number,
      controller: _numeroController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: '505',
          labelText: 'Numeración *'),
    );

    final CiudadCombo ciudadCombo =
        CiudadCombo(onChange: (newvalue) => this.ciudad = newvalue, dropdownValue: this.ciudad,);

    final Form form = Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ciudadCombo,
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: calle,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: numero,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: referencia,
          )
        ],
      ),
    );

    return form;
  }
}

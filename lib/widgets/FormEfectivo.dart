import 'package:flutter/material.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';

class FormularioEfectivo extends StatelessWidget {
  final PedidoAnyEntity entityModel;
  final PedidoAnyController controller;

  FormularioEfectivo(
      {Key? key, required this.entityModel, required this.controller}) {
    controller.validate = validate;
    controller.save = save;
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _abonaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    llenarCampos();

    Widget abonaField = TextFormField(
      keyboardType: TextInputType.number,
      controller: _abonaController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Ej: \$650',
          labelText: 'Con Cuanto Abona \* '),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese con cuanto va a pagar';
        }
        return null;
      },
      onSaved: (newValue) => entityModel.descripcion = _abonaController.text,
    );

    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 35),
            child: Text(
              "Pago en Efectivo",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          abonaField
        ],
      ),
    );
  }

  bool validate() {
    return formkey.currentState!.validate();
  }

  void save() {
    entityModel.medioPago = "Efectivo";
    entityModel.pagoEfectivo = double.tryParse(_abonaController.text);
  }

  void llenarCampos() {
    if (entityModel.medioPago == "Efectivo") {
      _abonaController.text = entityModel.pagoEfectivo.toString();
    }
  }
}

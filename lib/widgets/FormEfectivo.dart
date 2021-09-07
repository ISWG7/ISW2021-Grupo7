import 'package:flutter/material.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';

class FormularioEfectivo extends StatelessWidget {
  final PedidoAnyEntity entityModel;
  final GlobalKey<FormState> formkey;
  FormularioEfectivo({Key? key, required this.formkey, required this.entityModel})
      : super(key: key);

  final TextEditingController _abonaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
        children: <Widget>[           Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 35),
          child: Text("Pago en Efectivo", style:Theme.of(context).textTheme.headline4 ,),
        ) , abonaField],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';

class FormularioAnythingDesc extends StatelessWidget {
  PedidoAnyEntity entityModel;
  GlobalKey<FormState> formkey;
  FormularioAnythingDesc(
      {Key? key, required this.formkey, required this.entityModel})
      : super(key: key);
  final TextEditingController _descController = TextEditingController();

  // Build se ejecuta en cada frame ( conceptualmente)
  @override
  Widget build(BuildContext context) {
    Widget descField = TextFormField(
     keyboardType: TextInputType.multiline,
      maxLines: 7,
      controller: _descController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Que quiere llevar ',
          labelText: 'Descripcion \* '),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese una descripcion';
        }
        return null;
      },
      onSaved: (newValue) => entityModel.descripcion = _descController.text,
    );

    Form form = Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[descField],
      ),
    );

    return SingleChildScrollView(child: form);
  }
}

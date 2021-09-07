import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';

class FormularioAnythingDesc extends StatefulWidget {
  PedidoAnyEntity entityModel;
  GlobalKey<FormState> formkey;
  FormularioAnythingDesc(
      {Key? key, required this.formkey, required this.entityModel})
      : super(key: key);

  @override
  _FormularioAnythingDescState createState() => _FormularioAnythingDescState();
}

class _FormularioAnythingDescState extends State<FormularioAnythingDesc> {
  final TextEditingController _descController = TextEditingController();

  XFile? imagen = XFile("");
  bool previewVisible = false;

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
      onSaved: (newValue) =>
          widget.entityModel.descripcion = _descController.text,
    );
    final Widget agregarFotoButton = Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
          onPressed: seleccionarArchivo, child: Text("Agregar una foto")),
    );

    Widget preview = Visibility(
      visible: previewVisible,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 200,
          height: 300,
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(width: 5.0, color: Colors.pink.shade400),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(imagen!.path),
            ),
          ),
        ),
      ),
    );

    Form form = Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: widget.formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 35),
            child: Text(
              "¿ Que buscamos ?",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          descField,
          preview,
          agregarFotoButton,
        ],
      ),
    );

    return SingleChildScrollView(child: form);
  }

  Future<void> seleccionarArchivo() async {
    var picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagen = picked;
      previewVisible = true;
    });
  }
}

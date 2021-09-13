import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp_isw/FirebaseServices/CloudStorage.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';

class FormularioAnythingDesc extends StatefulWidget {
  final PedidoAnyController controller;
  final PedidoAnyEntity entityModel;
  FormularioAnythingDesc(
      {Key? key, required this.entityModel, required this.controller})
      : super(key: key);

  @override
  FormularioAnythingDescState createState() =>
      FormularioAnythingDescState(controller);
}

class FormularioAnythingDescState extends State<FormularioAnythingDesc> {
  FormularioAnythingDescState(PedidoAnyController _controller) {
    _controller.validate = validate;
    _controller.save = save;
  }
  final TextEditingController _descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  XFile? imagen;
  bool previewVisible = false;

  @override
  void initState() {
    var path = widget.entityModel.pathImagen;
    if (path == null || path == "")
      imagen = XFile("");
    else {
      imagen = XFile(path);
      previewVisible = true;
    }
    _descController.text = widget.entityModel.descripcion ?? "";
    super.initState();
  }

  @override
  void didUpdateWidget(FormularioAnythingDesc oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller.validate = validate;
    widget.controller.save = save;
  }

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
      child: ElevatedButton.icon(
          onPressed: seleccionarArchivo,
          icon: Icon(Icons.add_a_photo),
          label: Text("Agregar una foto")),
    );

    Widget preview = Visibility(
      visible: previewVisible,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 250,
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(width: 5.0, color: Colors.pink.shade400),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(
                imagen!.path,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );

    Form form = Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formKey,
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

  bool validate() {
    // Solo validamos que se halla introducido una descripcion , la foto es opcional
    return formKey.currentState!.validate();
  }

  Future<void> save() async {
    formKey.currentState!.save();
    widget.entityModel.pathImagen = imagen!.name;

    // // Guardar en cloud
    CloudStorageService service = CloudStorageService.instance;
    var data = await imagen!.readAsBytes();
    service.uploadData(data, imagen!.mimeType!, imagen!.name);
  }
}

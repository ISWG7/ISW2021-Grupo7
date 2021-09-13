import 'package:flutter/material.dart';
import 'package:tp_isw/entities/DireccionEntity.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';
import 'package:tp_isw/widgets/ComboCiudad.dart';

class FormularioDireccion extends StatefulWidget {
  final PedidoAnyController controller;
  final PedidoAnyEntity entityModel;
  final bool esEntrega;

  FormularioDireccion(
      {Key? key,
      required this.entityModel,
      required this.esEntrega,
      required this.controller});

  @override
  _FormularioDireccionState createState() =>
      _FormularioDireccionState(controller);
}

class _FormularioDireccionState extends State<FormularioDireccion> {
  _FormularioDireccionState(PedidoAnyController _controller) {
    _controller.validate = validate;
    _controller.save = save;
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String ciudad = 'Cordoba';
  final TextEditingController _referenciaController = TextEditingController();
  final TextEditingController _calleController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  @override
  void initState() {
    llenarCampos();
    super.initState();
  }

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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese una calle';
        }
        return null;
      },
    );

    Widget numero = TextFormField(
      keyboardType: TextInputType.number,
      controller: _numeroController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: '505',
          labelText: 'Numeración *'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese una numeracion';
        }
        return null;
      },
    );

    final CiudadCombo ciudadCombo = CiudadCombo(
      onChange: (newvalue) => this.setState(() {
        ciudad = newvalue;
      }),
      dropdownValue: ciudad,
    );

    final Form form = Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 35),
            child: Text(
              (widget.esEntrega)
                  ? "¿ A donde lo entregamos ?"
                  : "¿ A donde lo vamos a buscar ?",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ciudadCombo,
                  )),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: calle,
                ),
              ),
              Flexible(
                flex: 2,
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

    return SingleChildScrollView(child: form);
  }

  bool validate() {
    return formkey.currentState!.validate();
  }

  void save() {
    var aux = DireccionEntity(
        ciudad,
        _calleController.text,
        int.tryParse(
          _numeroController.text,
        )!,
        _referenciaController.text);
    if (widget.esEntrega) {
      widget.entityModel.entrega = aux;
    } else {
      widget.entityModel.retiro = aux;
    }
  }

  @override
  void didUpdateWidget(FormularioDireccion oldWidget) {
    super.didUpdateWidget(oldWidget);
    llenarCampos();
    widget.controller.save = save;
    widget.controller.validate = validate;
  }

  void llenarCampos() {
    // Primero preguntamos si es de entrega o de retiro
    if (widget.esEntrega) {
      //luego pregunto si ya tenia algo cargado o no
      if (widget.entityModel.entrega != null) {
        DireccionEntity entrega = widget.entityModel.entrega!;

        ciudad = entrega.ciudad;
        _referenciaController.text = entrega.referencia ?? "";
        _numeroController.text = entrega.numeracion.toString();
        _calleController.text = entrega.calle;
      } else {
        ciudad = 'Cordoba';
        _referenciaController.text = "";
        _calleController.text = "";
        _numeroController.text = "";
      }
    } else {
      if (widget.entityModel.retiro != null) {
        DireccionEntity retiro = widget.entityModel.retiro!;
        ciudad = retiro.ciudad;
        _referenciaController.text = retiro.referencia ?? "";
        _numeroController.text = retiro.numeracion.toString();
        _calleController.text = retiro.calle;
      }
    }
  }
}

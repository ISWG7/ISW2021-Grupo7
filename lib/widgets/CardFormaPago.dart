import 'package:flutter/material.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/widgets/FormTarjeta.dart';

import 'FormEfectivo.dart';

class FormaPago extends StatefulWidget {
  final PedidoAnyEntity entityModel;
  final GlobalKey<FormState> formkey;

  const FormaPago({Key? key, required this.entityModel, required this.formkey})
      : super(key: key);

  @override
  _FormaPagoState createState() => _FormaPagoState();
}

class _FormaPagoState extends State<FormaPago> {
  final String text1 = "Efectivo";
  final String text2 = "Tarjeta";
  late String forma;
  bool mostrarCard = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle =
        Theme.of(context).textTheme.headline3!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            );

    Widget card = Card(
      child: Column( mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              "Como desea abonar su pedido",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("El coste  total de su pedido es de \$150 - HARDCODEADO"  ,style: Theme.of(context).textTheme.headline6,),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => this.setState(() {
                    forma = text1;
                    mostrarCard = false;
                  }),
                  child: Text(
                    text1,
                    style: _textStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => this.setState(() {
                    forma = text2;
                    mostrarCard = false;
                  }),
                  child: Text(
                    text2,
                    style: _textStyle,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

    return (mostrarCard)
        ? card
        : (forma == "Efectivo")
            ? FormularioEfectivo(
                formkey: widget.formkey, entityModel: widget.entityModel)
            : FormTarjeta(formKey: widget.formkey);
  }
}

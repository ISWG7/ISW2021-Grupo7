import 'package:flutter/material.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';
import 'package:tp_isw/widgets/FormTarjeta.dart';

import 'FormEfectivo.dart';

class FormaPago extends StatefulWidget {
  final PedidoAnyEntity entityModel;
  final PedidoAnyController controller;

  const FormaPago(
      {Key? key, required this.entityModel, required this.controller})
      : super(key: key);

  @override
  _FormaPagoState createState() => _FormaPagoState();
}

class _FormaPagoState extends State<FormaPago> {
  static const COSTOXMETRO = 0.5;
  static const COSTO_INTERUBANO = 500;
  static const COSTO_ESTANDAR = 300;

  final String text1 = "Efectivo";
  final String text2 = "Tarjeta";
  double costo = 0;
  bool cobroPorMetro = false;
  bool interciudad = false;
  late String forma;
  bool mostrarCard = true;

  @override
  void initState() {
    super.initState();
    calcularCosto();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle =
        Theme.of(context).textTheme.headline3!.copyWith(
              height: 26,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            );

    Widget card = Card(
      elevation: 8.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              "Como desea abonar su pedido",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "El coste  total de su pedido es de $costo",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Visibility(
            child: Text(
                "Este es un envio Interurbano sin especificar ubicaciones. Tiene Recargo"),
            visible: interciudad,
          ),
          Visibility(
            child:
                Text("Este envio se esta facturando por metro a $COSTOXMETRO"),
            visible: cobroPorMetro,
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
        : Column(
            children: [
              (forma == "Efectivo")
                  ? FormularioEfectivo(
                      entityModel: widget.entityModel,
                      controller: widget.controller,
                    )
                  : Expanded(
                      child: FormTarjeta(
                      entity: widget.entityModel,
                      controller: widget.controller,
                    )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () => this.setState(() => mostrarCard = true),
                    child: Text("Cambiar metodo de pago")),
              )
            ],
          );
  }

  void calcularCosto() {
    // si se especifico la distancia con el mapa entonces se cobra por metro
    if (widget.entityModel.distancia != null) {
      setState(() {
        costo = widget.entityModel.distancia! * COSTOXMETRO;
        cobroPorMetro = true;
      });
    } else {
      // si no simplemente se cobra por una entrega en misma ciudad
      setState(() => costo = COSTO_ESTANDAR.floorToDouble());
      //si las ciudades son distintas  y no se esepecifico se cobra un plus
      if (widget.entityModel.entrega!.ciudad !=
          widget.entityModel.retiro!.ciudad) {
        setState(() {
          costo = costo + COSTO_INTERUBANO;
          interciudad = true;
        });
      }
    }
  }
}

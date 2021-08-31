import 'package:flutter/material.dart';
import 'package:tp_isw/routes/PedidoStepper.dart';

class PedidoAnything extends StatelessWidget {
  const PedidoAnything({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('PEDI "LO QUE SEA"',
              style: Theme.of(context).textTheme.headline5),
        ),
        body: PedidoStepper());
  }
}

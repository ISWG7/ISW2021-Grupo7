import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/widgets/CardFormaPago.dart';
import 'package:tp_isw/widgets/FormularioAny_Desc.dart';
import 'package:tp_isw/widgets/FormularioAny_Direccion.dart';
import 'package:tp_isw/widgets/HoraEntrega.dart';

class PedidoStepper extends StatefulWidget {
  const PedidoStepper({Key? key}) : super(key: key);

  @override
  _PedidoStepperState createState() => _PedidoStepperState();
}

class _PedidoStepperState extends State<PedidoStepper> {
  // Lista con los Pasos del stepper
  late List<Widget> steps;

  // Key de los forms, usado para validar
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  // Variables donde voy guardando el progreso del stepper


  // Modelo de datos , en donde voy a guardar los cambios
  // se lo mando a los formularios para que lo completen;
  // al final lo persisto
  final PedidoAnyEntity entity = new PedidoAnyEntity();

  @override
  void initState() {
    super.initState();
    // inicializo los Pasos de mi stepper
    crearWidgetsSteps();
  }

  int activeStep = 0; // El step activo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedi Lo que sea"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IconStepper(
              nextButtonIcon: Icon(Icons.forward_outlined),
              previousButtonIcon: Icon(
                Icons.forward_outlined,
                textDirection: TextDirection.rtl,
              ),
              stepReachedAnimationEffect: Curves.bounceOut,
              stepReachedAnimationDuration: Duration(seconds: 1),
              stepColor: Colors.amber.shade200,
              activeStepColor: Colors.pink.shade300,
              icons: [
                Icon(Icons.description_outlined),
                Icon(Icons.location_on_outlined),
                Icon(Icons.home_outlined),
                Icon(Icons.map),
                Icon(Icons.payment_outlined),
                Icon(Icons.access_time_outlined)
              ],
              direction: Axis.horizontal,
              activeStep: activeStep,
              onStepReached: (index) => setState(() => activeStep = index),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: content(activeStep)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // METODOS AUXILIARES

  Widget content(int activeStep) {
    if (activeStep < steps.length) {
      return steps[activeStep];
    } else
      return Text("Error");
  }

  void asdf() {}

  void crearWidgetsSteps() {
    final formdesc = FormularioAnythingDesc(
      formkey: formKeys[0],
      entityModel: entity,
    );
    final formdirec = FormularioAnythingDireccion(
      formkey: formKeys[1],
      entityModel: entity,
      title: "¿ A donde lo vamos a buscar ?",
    );
    final formdirec2 = FormularioAnythingDireccion(
      formkey: formKeys[2],
      entityModel: entity,
      title: "¿ A donde lo entregamos ?",
    );

    final Widget formaPago =
        FormaPago(entityModel: entity, formkey: formKeys[3],);

    final Widget horaPicker = HoraEntrega();

    steps = [
      formdesc,
      formdirec,
      formdirec2,
      formaPago,
      horaPicker
    ];
  }
}

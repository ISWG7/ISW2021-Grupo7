import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tp_isw/FirebaseServices/firestore.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';
import 'package:tp_isw/widgets/CardFormaPago.dart';
import 'package:tp_isw/widgets/FlutterMap.dart';
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

  //Controlleres de , usado para validar y salvar
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  final List<PedidoAnyController> controllers = [
    PedidoAnyController(),
    PedidoAnyController(),
    PedidoAnyController(),
    PedidoAnyController(),
    PedidoAnyController(),
    PedidoAnyController()
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
  bool steppingEnabled = false;
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
            // TODO CAmbiarlo por un builder
            SizedBox(
              width: 300,
              child: IconStepper(
                enableNextPreviousButtons: false,
                alignment: Alignment.centerLeft,

                // TODO Ver si lo dejamos en true ( y que saltee pasos )
                //  o en false ( con bug de que se puede hacer click y no pasa nada )
                steppingEnabled: true,
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: content(activeStep)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: back,
                    icon: Icon(
                      Icons.forward_outlined,
                      textDirection: TextDirection.rtl,
                    ),
                    label: Text("Atras"),
                  ),
                  ElevatedButton.icon(
                    onPressed: next,
                    icon: Icon(Icons.forward_outlined),
                    label: Text("Siguiente"),
                  ),
                ],
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
    }
    FirestoreService.instance.createPedidoAnything(entity);
    return Container();
  }

  void next() {
    if (activeStep < steps.length) {
      if (controllers[activeStep].validate()) {
        controllers[activeStep].save();
        setState(() {
          activeStep++;
        });
      }
    }
  }

  void back() {
    if (activeStep > 0) {
      setState(() {
        activeStep--;
      });
    }
  }

  void crearWidgetsSteps() {
    final formdesc = FormularioAnythingDesc(
      entityModel: entity,
      controller: controllers[0],
    );

    final formRetiro = FormularioDireccion(
      key: GlobalKey(debugLabel: "1"),
      controller: controllers[1],
      entityModel: entity,
      esEntrega: false,
    );
    final formEntrega = FormularioDireccion(
      key: GlobalKey(debugLabel: "2"),
      controller: controllers[2],
      entityModel: entity,
      esEntrega: true,
    );

    final Widget formaPago = FormaPago(
      entityModel: entity,
      controller: controllers[4],
    );
    final Widget map = Map(
      controller: controllers[3],
      entity: entity,
    );

    final Widget horaPicker = HoraEntrega(
      entity: entity,
      controller: controllers[5],
    );

    steps = [
      formdesc,
      formRetiro,
      formEntrega,
      map,
      formaPago,
      horaPicker,
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/widgets/FormularioAny_Desc.dart';
import 'package:tp_isw/widgets/Map.dart';

class PedidoStepper extends StatefulWidget {
  const PedidoStepper({Key? key}) : super(key: key);

  @override
  _PedidoStepperState createState() => _PedidoStepperState();
}

class _PedidoStepperState extends State<PedidoStepper> {
  // TODO ESTE HARDCODE WACALA
  // Key de los forms

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  bool stepperCompleted = false;
  late List<Widget> steps;
  PedidoAnyEntity entity = new PedidoAnyEntity();

  @override
  void initState() {
    super.initState();
    final formdesc = FormularioAnythingDesc(
      formkey: formKeys[0],
      entityModel: entity,
    );
    final formdesc2 = FormularioAnythingDesc(
      formkey: formKeys[1],
      entityModel: entity,
    );

    final map = Map();
    steps = [formdesc, formdesc2, map];
  }

  int activeStep = 0; // Initial step set to 5.
  int upperBound = 3; // upperBound MUST BE total number of icons minus 1

  Widget content(int activeStep) {
    if (activeStep < upperBound) {
      return steps[activeStep];
    } else
      return Text("Error");
  }

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
                Icon(Icons.motorcycle_outlined),
                Icon(Icons.motorcycle_outlined),
                Icon(Icons.motorcycle_outlined),
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

    // return Column(
    //   children: [
    //     Expanded(
    //       child: Stepper(
    //         steps: steps,
    //         currentStep: currentStep,
    //         controlsBuilder: (context, {onStepCancel, onStepContinue}) {
    //           return Padding(
    //             padding: const EdgeInsets.all(14.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: <Widget>[
    //                 TextButton(
    //                   onPressed: onStepCancel,
    //                   child: const Text('VOLVER'),
    //                 ),
    //                 ElevatedButton(
    //                   onPressed: onStepContinue,
    //                   child: const Text('SIGUIENTE'),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //         onStepContinue: next,
    //         onStepTapped: (step) => goTo(step),
    //         onStepCancel: cancel,
    //       ),
    //     )
    //   ],
    // );
  }
}

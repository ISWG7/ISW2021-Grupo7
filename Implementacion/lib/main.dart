import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tp_isw/routes/PedidoStepper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Si el future se completo retorna a la app
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            // localizationsDelegates: []  ,
            // supportedLocales: [const Locale('es','ARG')],
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Container(color: Colors.amber, child: PedidoStepper()),
          );
        }

        return Container();
      },
    );
  }
}

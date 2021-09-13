import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Singleton
  FirestoreService._singleton();

  static final FirestoreService _service = FirestoreService._singleton();

  factory FirestoreService() => _service;

  static FirestoreService get instance => _service;

  Future<void> createPedidoAnything(PedidoAnyEntity pedidoAnyEntity) async {
    String path = "PedidoAnything";
    CollectionReference collection = _firebaseFirestore.collection(path);
    collection
        .add(pedidoAnyEntity.toJson())
        .then((value) => print("Pedido Cargado"))
        .catchError((error) => print("Error al cargar el pedido: $error"));
  }
}

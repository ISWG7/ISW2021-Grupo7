
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class CloudStorageService {
  final firebase_storage.FirebaseStorage _firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  //Singleton
  CloudStorageService._singleton();

  static final CloudStorageService _service = CloudStorageService._singleton();

  factory CloudStorageService() => _service;

  static CloudStorageService get instance => _service;

  //obtiene una URL de descarga para el path
  Future<String> downloadURL(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('path')
        .getDownloadURL();
    return downloadURL;
  }
  //

  Future<void> uploadData(Uint8List data, String type, String name) async {

    print('nombre $name');
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('uploads/$name');

    try {
      // Upload raw data.
      await ref.putData(data);
    } on Exception catch (e) {
      print("$e");
    }
  }

  // CODIGO MUERTO QUE NO FUNCIONA

//  Future<void> upload(String path, data) async {
//    File file = File.fromRawPath(data);
//    print(' path $path');
//
//    try {
//      await _firebaseStorage.ref('Imagenes/$path').putFile(file);
//    } on FirebaseException catch (e) {
//      print('$e');
//    }
//  }
// @deprecated
//  Future<void> uploadBlob( String blobpath) async {
//    firebase_storage.Reference ref = _firebaseStorage.ref("");
//    print('blob path $blobpath');
//    await ref.putBlob(blobpath);
//
//
//  }

}

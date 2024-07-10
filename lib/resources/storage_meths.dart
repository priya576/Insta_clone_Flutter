import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Storage_meths {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // add img to storage
  Future<String> upload_img(
      String childname, Uint8List file, bool ispost) async {
    Reference reference = firebaseStorage
        .ref()
        .child(childname)
        .child(firebaseAuth.currentUser!.uid);

    if (ispost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();

    return downloadurl;
  }

  Future<String> uploadVideo(
      String childName, File videoFile, bool isPost) async {
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child(childName)
          .child(FirebaseAuth.instance.currentUser!.uid);

      if (isPost) {
        String id = const Uuid().v1();
        reference = reference.child(id);
      }

      UploadTask uploadTask = reference.putFile(videoFile);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> upload_story(String childname, Uint8List file) async {
    Reference reference = firebaseStorage
        .ref()
        .child(childname)
        .child(firebaseAuth.currentUser!.uid);

    String id = const Uuid().v1();
    reference = reference.child(id);

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();

    return downloadurl;
  }
}

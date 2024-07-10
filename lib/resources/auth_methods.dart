import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage_meths.dart';

class Auth_meths {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // fetch user details
  Future<model.User> gwt_userdets() async {
    User currentuser = auth.currentUser!;

    DocumentSnapshot snapshot = await firebaseFirestore.collection('users').doc(currentuser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  // sign up
  Future<String> sgnupuser({
    required String email,
    required String pass,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some Error Occured";

    try {
      if (email.isNotEmpty || pass.isNotEmpty ||username.isNotEmpty ||bio.isNotEmpty) {
        // register a user
        UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: pass);

        String picsUrl = await Storage_meths().upload_img('ProfilePics', file, false);

        // user to database

        model.User user = model.User(
          username: username,
          uid : credential.user!.uid,
          email : email,
          bio : bio,
          followers : [],
          following : [],
          photourl : picsUrl,
        );

        await firebaseFirestore.collection('users').doc(credential.user!.uid).set(user.toJson());
        res = "Success";
      }
    } catch(e) {
      res = e.toString();
    }
    return res;
  }

  // Log in

  Future<String> login_user({
    required String email,
    required String pass
}) async {
    String res = "Some Error Occurred";

    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: pass);
        res = "Success";
      } else {
        res = "Please Enter all the details Correctly";
      }
    } catch(e) {
      res = e.toString();
    }
    return res;
  }

  // Log Out
  Future<void> log_out() async {
    await auth.signOut();
  }

}

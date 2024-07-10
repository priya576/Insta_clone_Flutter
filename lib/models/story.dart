import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Add_Story {
  final String des;
  final String uid;
  final String username;
  final String storyid;
  final date;
  final String storyurl;
  final String profimg;

  const Add_Story({
    required this.des,
    required this.uid,
    required this.username,
    required this.storyid,
    required this.date,
    required this.storyurl,
    required this.profimg,
  });

  Map<String, dynamic> toJson() => {
    'description': des,
    'uid': uid,
    'username': username,
    'storyid': storyid,
    'date': date,
    'storyurl': storyurl,
    'profImg': profimg,
  };

  static Add_Story fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Add_Story(
      des: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      storyid: snapshot['storyid'],
      date: snapshot['date'],
      storyurl: snapshot['storyurl'],
      profimg: snapshot['profImg'],
    );
  }
}

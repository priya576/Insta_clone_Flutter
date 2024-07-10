import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reels {
  final String des;
  final String uid;
  final String username;
  final String reelid;
  final String reelurl;
  final String profimg;
  final likes;

  const Reels({
    required this.des,
    required this.uid,
    required this.username,
    required this.reelid,
    required this.reelurl,
    required this.profimg,
    required this.likes
  });

  Map<String, dynamic> toJson() => {
    'description': des,
    'uid': uid,
    'username': username,
    'reelid': reelid,
    'reelurl': reelurl,
    'profImg': profimg,
    'likes' : likes,
  };

  static Reels fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Reels(
      des: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      reelid: snapshot['reelid'],
      reelurl: snapshot['reelurl'],
      profimg: snapshot['profImg'],
      likes: snapshot['likes'],
    );
  }
}

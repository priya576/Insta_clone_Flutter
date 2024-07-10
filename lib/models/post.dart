import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post_stuff {
  final String des;
  final String uid;
  final String username;
  final String postid;
  final date;
  final String posturl;
  final String profimg;
  final likes;

  const Post_stuff({
    required this.des,
    required this.uid,
    required this.username,
    required this.postid,
    required this.date,
    required this.posturl,
    required this.profimg,
    required this.likes
  });

  Map<String, dynamic> toJson() => {
    'description': des,
    'uid': uid,
    'username': username,
    'postId': postid,
    'date': date,
    'postUrl': posturl,
    'profImg': profimg,
    'likes' : likes,
  };

  static Post_stuff fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post_stuff(
        des: snapshot['description'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postid: snapshot['postId'],
        date: snapshot['date'],
        posturl: snapshot['postUrl'],
        profimg: snapshot['profImg'],
        likes: snapshot['likes'],
    );
  }
}

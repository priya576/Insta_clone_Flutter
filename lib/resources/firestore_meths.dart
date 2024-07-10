import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/models/reel.dart';
import 'package:instagram/models/story.dart';
import 'package:instagram/resources/storage_meths.dart';
import 'package:instagram/utils/utils.dart';
import 'package:uuid/uuid.dart';

class Firestore_meths {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // upload post
  Future<String> upload_post(
    String des,
    Uint8List file,
    String uid,
    String username,
    String prof_img,
  ) async {
    String res = "Some Error Occurred";

    try {
      String photoUrl = await Storage_meths().upload_img('posts', file, true);
      String postId = const Uuid().v1();

      Post_stuff post = Post_stuff(
          des: des,
          uid: uid,
          username: username,
          postid: postId,
          date: DateTime.now(),
          posturl: photoUrl,
          profimg: prof_img,
          likes: []);

      firebaseFirestore.collection("posts").doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //upload videos
  Future<String> upload_reels(
      String des,
      File file,
      String uid,
      String username,
      String prof_img,
      ) async {
    String res = "Some Error Occurred";

    try {
      String photoUrl = await Storage_meths().uploadVideo('reels', file, true);
      String reelid = const Uuid().v1();

      Reels reel = Reels(
          des: des,
          uid: uid,
          username: username,
          reelid: reelid,
          reelurl: photoUrl,
          profimg: prof_img,
          likes: []);

      firebaseFirestore.collection("reels").doc(reelid).set(
        reel.toJson(),
      );
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // upload story
  Future<String> upload_myStory(
      String des,
      Uint8List file,
      String uid,
      String username,
      String prof_img,
      ) async {
    String res = "Some Error Occurred";

    try {
      String photoUrl = await Storage_meths().upload_story('stories', file);
      String storyid = const Uuid().v1();

      Add_Story story = Add_Story(
          des: des,
          uid: uid,
          username: username,
          storyid: storyid,
          date: DateTime.now(),
          storyurl: photoUrl,
          profimg: prof_img,
      );

      firebaseFirestore.collection("stories").doc(storyid).set(
        story.toJson(),
      );
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeReel(String reelid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('reels').doc(reelid).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore.collection('reels').doc(reelid).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // post Comments
  Future<void> post_comms(String postid, String uid, String text, String name,
      String profilepic) async {
    try {
      if (text.isNotEmpty) {
        String commId = const Uuid().v1();
        await firebaseFirestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commId)
            .set({
          "profpic": profilepic,
          "name": name,
          "uid": uid,
          "text": text,
          "commId": commId,
          "date": DateTime.now(),
        });
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //post reel comms
  Future<void> comms_reels(String reelid, String uid, String text, String name,
      String profilepic) async {
    try {
      if (text.isNotEmpty) {
        String commId = const Uuid().v1();
        await firebaseFirestore
            .collection('reels')
            .doc(reelid)
            .collection('comments')
            .doc(commId)
            .set({
          "profpic": profilepic,
          "name": name,
          "uid": uid,
          "text": text,
          "commId": commId,
          "date": DateTime.now(),
        });
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> dlt_post(String postid) async {
    try {
      await firebaseFirestore.collection('posts').doc(postid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followid) async {
    try {
      DocumentSnapshot snap =
          await firebaseFirestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followid)) {
        await firebaseFirestore.collection('users').doc(followid).update({
          "followers": FieldValue.arrayRemove([uid])
        });
        await firebaseFirestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayRemove([followid])
        });
      }
      else {
        await firebaseFirestore.collection('users').doc(followid).update({
          "followers": FieldValue.arrayUnion([uid])
        });
        await firebaseFirestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayUnion([followid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

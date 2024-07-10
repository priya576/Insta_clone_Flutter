import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/prof_screen.dart';
import 'package:instagram/screens/reels_screen.dart';
import 'package:instagram/screens/search_screen.dart';
import '../screens/add_post_screen.dart';

const webscreen = 600;

List<Widget> homeScreenItems = [
  const Feeds_screen(),
  const Search_screen(),
  const Add_post(),
  const ReelsScreen(),
  Prof_screen(uid: FirebaseAuth.instance.currentUser!.uid),
];
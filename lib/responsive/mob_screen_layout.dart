import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user.dart' as model;

class Mob_layout extends StatefulWidget {
  const Mob_layout({super.key});

  @override
  State<Mob_layout> createState() => _Mob_layout();
}

class _Mob_layout extends State<Mob_layout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationtapped(int page) {
    pageController.jumpToPage(page);
  }

  void onpagechanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onpagechanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: _page == 0? primaryColor : secondaryColor,),backgroundColor: primaryColor,label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.search,color: _page == 1? primaryColor : secondaryColor,),backgroundColor: primaryColor,label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined,color: _page == 2? primaryColor : secondaryColor,),backgroundColor: primaryColor,label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.ondemand_video,color: _page == 3? primaryColor : secondaryColor,),backgroundColor: primaryColor,label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: _page == 4? primaryColor : secondaryColor,),backgroundColor: primaryColor,label: '',),
        ],
        onTap: navigationtapped,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_meths.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/comm_display.dart';

class Comm_screen extends StatefulWidget {
  final snap;
  final int commIndex;
  const Comm_screen({super.key, this.snap, required this.commIndex});

  @override
  State<Comm_screen> createState() => _Comm_screenState();
}

class _Comm_screenState extends State<Comm_screen> {
  final TextEditingController comm_con = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    comm_con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User_provider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          "Comments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),

      body: StreamBuilder(
        stream: widget.commIndex == 0
            ? FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .orderBy('date', descending: true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('reels')
                .doc(widget.snap['reelid'])
                .collection('comments')
                .orderBy('date', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => Comm_display(
                snap: (snapshot.data! as dynamic).docs[index].data()),
          );
        },
      ),

      // commenting
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photourl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  child: TextField(
                    controller: comm_con,
                    decoration: InputDecoration(
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (widget.commIndex == 0) {
                    await Firestore_meths().post_comms(widget.snap['postId'],
                        user.uid, comm_con.text, user.username, user.photourl);
                  }
                  else {
                    await Firestore_meths().comms_reels(widget.snap['reelid'],
                        user.uid, comm_con.text, user.username, user.photourl);
                  }
                  setState(() {
                    comm_con.text = "";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "Post", style: TextStyle(color: blueColor),
                    // icon: const Icon(
                    //   Icons.send_sharp,
                    //   color: primaryColor,
                    // ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/widgets/posts_display.dart';
import 'package:instagram/widgets/story_display.dart';

class Feeds_screen extends StatefulWidget {
  const Feeds_screen({super.key});

  @override
  State<Feeds_screen> createState() => _Feeds_screenState();
}

class _Feeds_screenState extends State<Feeds_screen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webscreen
          ? null
          : AppBar(
        backgroundColor: width > webscreen
            ? webBackgroundColor
            : mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send_sharp,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // stories
          Container(
            height: 105,
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('stories').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Map to group stories by user
                Map<String, List<Map<String, dynamic>>> userStories = {};

                for (var doc in snapshot.data!.docs) {
                  var storyData = doc.data();
                  var uid = storyData['uid']; // User ID

                  if (!userStories.containsKey(uid)) {
                    userStories[uid] = [];
                  }
                  userStories[uid]!.add(storyData);
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userStories.keys.length,
                  itemBuilder: (context, index) {
                    var uid = userStories.keys.elementAt(index);
                    var stories = userStories[uid]!;

                    // Pass all stories of the user to the StoryWidget
                    return StoryWidget(snap: stories);
                  },
                );
              },
            ),
          ),
          // posts
          Expanded(
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width > webscreen ? width * 0.3 : 0,
                      vertical: width > webscreen ? 15 : 0,
                    ),
                    child: Post_display(
                      snap: snapshot.data?.docs[index].data(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

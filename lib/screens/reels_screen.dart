import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

import '../widgets/reels_display.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      int? newIndex = _pageController.page?.round();
      if (_currentIndex != newIndex) {
        setState(() {
          _currentIndex = newIndex!;
        });
        _playCurrentVideo();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _playCurrentVideo() {
    if (_currentIndex < _controllers.length) {
      for (int i = 0; i < _controllers.length; i++) {
        if (i == _currentIndex) {
          _controllers[i].play();
        } else {
          _controllers[i].pause();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reels').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controllers.length != snapshot.data?.docs.length) {
            _controllers = snapshot.data!.docs.map<VideoPlayerController>((doc) {
              var controller = VideoPlayerController.network(doc['reelurl']);
              controller.initialize().then((_) {
                setState(() {});
                if (_controllers.indexOf(controller) == 0) {
                  controller.play();
                }
                controller.setLooping(true);
              });
              return controller;
            }).toList();
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var reel = snapshot.data!.docs[index];
              return ReelItem(
                description: reel['description'],
                videoUrl: reel['reelurl'],
                username: reel['username'],
                profImg: reel['profImg'],
                autoPlay: index == _currentIndex,
                snap: snapshot.data?.docs[index].data(),
              );
            },
          );
        },
      ),
    );
  }
}

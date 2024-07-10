import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_meths.dart';
import '../screens/comment_screen.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class ReelItem extends StatefulWidget {
  final String description;
  final String videoUrl;
  final String username;
  final String profImg;
  final bool autoPlay;
  final snap;

  const ReelItem({
    super.key,
    required this.description,
    required this.videoUrl,
    required this.username,
    required this.profImg,
    required this.autoPlay, this.snap,
  });

  @override
  _ReelItemState createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _videoController;
  int comments = 0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        if (widget.autoPlay) {
          _videoController.play();
        }
        _videoController.setLooping(true);
      });
    get_comms();
  }

  void get_comms() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reels')
          .doc(widget.snap['reelid'])
          .collection('comments')
          .get();
      comments = querySnapshot.docs.length;
    } catch (e) {
      showSnakbar(e.toString(), context);
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoPlay && !_videoController.value.isPlaying) {
      _videoController.play();
    } else if (!widget.autoPlay && _videoController.value.isPlaying) {
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User_provider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        _videoController.value.isInitialized
            ? AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        )
            : const Center(child: CircularProgressIndicator()),
        const Positioned(
          top: 50,
          left: 10,
          child: Text(
            'Reels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Positioned(
          top: 50,
          right: 10,
          child: Icon(Icons.camera_alt, color: Colors.white),
        ),
        Positioned(
          bottom: 35,
          right: 10,
          child: Column(
            children: [
              IconButton(
                onPressed: () async => await Firestore_meths().likeReel(
                    widget.snap['reelid'], user.uid, widget.snap['likes']),
                icon: widget.snap['likes'].contains(user.uid)
                    ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
                    : const Icon(
                  Icons.favorite_border,
                  color: primaryColor,
                ),
              ),
               Text(
                "${widget.snap['likes'].length} Likes",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Comm_screen(
                      snap: widget.snap,
                      commIndex: 1,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: primaryColor,
                ),
              ),
               Text(
                '$comments Comments',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.profImg),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

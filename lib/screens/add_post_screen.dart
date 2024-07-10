import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_meths.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Add_post extends StatefulWidget {
  const Add_post({super.key});

  @override
  State<Add_post> createState() => _Add_postState();
}

class _Add_postState extends State<Add_post> {
  final TextEditingController des_con = TextEditingController();
  Uint8List? _file;
  XFile? videoFile;
  VideoPlayerController? controller;
  bool isloading = false;

  void post_images(
      String uid,
      String username,
      String prof_img,
      ) async {
    setState(() {
      isloading = true;
    });

    try {
      String res = await Firestore_meths()
          .upload_post(des_con.text, _file!, uid, username, prof_img);

      if (res == "Success") {
        setState(() {
          isloading = false;
        });
        showSnakbar("Posted Successfully", context);
        clearImg();
      } else {
        setState(() {
          isloading = false;
        });
        showSnakbar(res, context);
      }
    } catch (e) {
      showSnakbar(e.toString(), context);
    }
  }

  void post_videos(
      String uid,
      String username,
      String prof_img,
      ) async {
    setState(() {
      isloading = true;
    });

    try {
      String res = await Firestore_meths()
          .upload_reels(des_con.text, File(videoFile!.path), uid, username, prof_img);

      if (res == "Success") {
        setState(() {
          isloading = false;
        });
        showSnakbar("Posted Successfully", context);
        clearImg();
      } else {
        setState(() {
          isloading = false;
        });
        showSnakbar(res, context);
      }
    } catch (e) {
      showSnakbar(e.toString(), context);
    }
  }

  void story_images(
      String uid,
      String username,
      String prof_img,
      ) async {
    setState(() {
      isloading = true;
    });

    try {
      String res = await Firestore_meths()
          .upload_myStory(des_con.text, _file!, uid, username, prof_img);

      if (res == "Success") {
        setState(() {
          isloading = false;
        });
        showSnakbar("Posted Successfully", context);
        clearImg();
      } else {
        setState(() {
          isloading = false;
        });
        showSnakbar(res, context);
      }
    } catch (e) {
      showSnakbar(e.toString(), context);
    }
  }

  selectImg(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pick_img(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pick_img(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  selectVdo(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Reel"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Video"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile file = await pickVideo(
                    ImageSource.camera,
                  );
                  setState(() {
                    videoFile = file;
                  });
                  initializeVideoPlayer();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile file = await pickVideo(
                    ImageSource.gallery,
                  );
                  setState(() {
                    videoFile = file;
                  });
                  initializeVideoPlayer();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImg() {
    setState(() {
      _file = null;
    });
  }

  void initializeVideoPlayer() {
    if (videoFile != null) {
      controller = VideoPlayerController.file(File(videoFile!.path))
        ..initialize().then((_) {
          setState(() {});
          controller!.play();
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    des_con.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User_provider>(context).getUser;

    return _file == null && videoFile == null
        ? Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.upload,
              size: 65,
              color: Colors.blueAccent,
            ),
            onPressed: () => selectImg(context),
          ),
          IconButton(
            icon: const Icon(
              Icons.upload,
              size: 65,
              color: Colors.red,
            ),
            onPressed: () => selectVdo(context),
          ),
        ],
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImg,
        ),
        title: const Text("Post Items"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () =>
                post_images(user.uid, user.username, user.photourl),
            child: const Text(
              "Post",
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          if(videoFile != null)
            TextButton(
              onPressed: () =>
                  post_videos(user.uid, user.username, user.photourl),
              child: const Text(
                "Reel",
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

          // story button
          TextButton(
            onPressed: () =>
                story_images(user.uid, user.username, user.photourl),
            child: const Text(
              "Story",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isloading
                ? const LinearProgressIndicator()
                : const Padding(
                padding: EdgeInsets.only(
                  top: 0,
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user.photourl,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: des_con,
                    decoration: const InputDecoration(
                      hintText: "Write a Caption",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                _file != null
                    ? SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                  ),
                )
                    : const SizedBox(
                  height: 45,
                  width: 45,
                ),
                const Divider(),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            if (controller != null && controller!.value.isInitialized)
              Container(
                height: 500,
                child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: VideoPlayer(controller!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

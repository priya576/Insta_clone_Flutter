import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pick_img(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  print('No img Selected');
}

showSnakbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}


pickVideo(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

   XFile? video = await imagePicker.pickVideo(
    source: source,
  );
  if (video != null) {
    return video;
  }
  print('No video selected');
}
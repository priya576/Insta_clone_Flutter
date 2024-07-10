import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/utils.dart';

import '../responsive/mob_screen_layout.dart';
import '../responsive/responsive_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/textfield.dart';

class Sgnup_page extends StatefulWidget {
  const Sgnup_page({super.key});

  @override
  State<Sgnup_page> createState() => Sgnpagestate();
}

class Sgnpagestate extends State<Sgnup_page> {
  final TextEditingController email_con = TextEditingController();
  final TextEditingController pass_con = TextEditingController();
  final TextEditingController bio_con = TextEditingController();
  final TextEditingController username_con = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    email_con.dispose();
    pass_con.dispose();
    bio_con.dispose();
    username_con.dispose();
  }

  void select_img() async {
    Uint8List im = await pick_img(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void navigatetologin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Login_page(),
      ),
    );
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await Auth_meths().sgnupuser(
      email: email_con.text,
      pass: pass_con.text,
      username: username_con.text,
      bio: bio_con.text,
      file: _image!,
    );

    setState(() {
      isLoading = false;
    });

    if (res != "Success") {
      showSnakbar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Res_layout(
              webscreenlayout: Web_layout(),
              mobscreenlayout: Mob_layout()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              // logo
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 62,
              ),
              const SizedBox(
                height: 40,
              ),
              // circular widget
              Stack(
                children: [
                  if (_image != null)
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  else
                    const CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                    ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: select_img,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: blueColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              // username
              Text_field(
                  text_controller: username_con,
                  hint: "Enter Your Username",
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 25,
              ),
              // email
              Text_field(
                  text_controller: email_con,
                  hint: "Enter Your Email",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 25,
              ),
              // pass
              Text_field(
                text_controller: pass_con,
                hint: "Enter Your Password",
                textInputType: TextInputType.text,
                ispassed: true,
              ),
              const SizedBox(
                height: 25,
              ),
              // bio
              Text_field(
                  text_controller: bio_con,
                  hint: "Enter Your Bio",
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 25,
              ),
              // button
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              // sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: navigatetologin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Already have an account?'),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigatetologin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/sgnup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/textfield.dart';

import '../responsive/mob_screen_layout.dart';
import '../responsive/responsive_screen.dart';
import '../responsive/web_screen_layout.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login_page> {
  final TextEditingController email_con = TextEditingController();
  final TextEditingController pass_con = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    email_con.dispose();
    pass_con.dispose();
  }

  void navigatetosgnup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Sgnup_page(),
      ),
    );
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await Auth_meths()
        .login_user(email: email_con.text, pass: pass_con.text);

    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Res_layout(
              webscreenlayout: Web_layout(), mobscreenlayout: Mob_layout()),
        ),
      );
    } else {
      showSnakbar(res, context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webscreen
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 30),
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
                height: 64,
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
              // button
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Log in'),
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
                    onTap: navigatetosgnup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Dont have an account?'),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigatetosgnup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Sign UP',
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

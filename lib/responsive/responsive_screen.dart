import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

class Res_layout extends StatefulWidget{
  final Widget webscreenlayout;
  final Widget mobscreenlayout;
  const Res_layout({super.key, required this.webscreenlayout, required this.mobscreenlayout});

  @override
  State<Res_layout> createState() => _Res_layoutState();
}

class _Res_layoutState extends State<Res_layout> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    User_provider user_provider = Provider.of(context, listen: false);
    await user_provider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        if (constraints.maxWidth > webscreen) {
          // web screen
          return widget.webscreenlayout;
        }
        // mobile screen
        return widget.mobscreenlayout;
      },
    );
  }
}
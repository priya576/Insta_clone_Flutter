import 'package:flutter/material.dart';

class Follow_button extends StatelessWidget {
  final Function()? function;
  final Color bgcolor;
  final Color borderclr;
  final String text;
  final Color textclr;
  const Follow_button(
      {super.key,
      required this.bgcolor,
      required this.borderclr,
      required this.text,
      required this.textclr,
        this.function,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: bgcolor,
            border: Border.all(color: borderclr),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: textclr),
          ),
          width: 250,
          height: 27,
        ),
      ),
    );
  }
}

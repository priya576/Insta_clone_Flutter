import 'package:flutter/material.dart';

class Text_field extends StatelessWidget {
  final TextEditingController text_controller;
  final bool ispassed;
  final String hint;
  final TextInputType textInputType;
  const Text_field(
      {super.key,
      required this.text_controller,
      this.ispassed = false,
      required this.hint,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: text_controller,
      decoration: InputDecoration(
        hintText: hint,
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: ispassed,
    );
  }
}

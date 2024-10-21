import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool hasPasswordLine;
  final TextEditingController controller;
  bool obscureText;

  MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.hasPasswordLine,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool passwordIsHide = true;

  void showPassword() {
    setState(() {
      passwordIsHide = !passwordIsHide;
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: widget.hintText,
        suffixIcon: widget.hasPasswordLine
            ? GestureDetector(
                onTap: showPassword,
                child: passwordIsHide
                    ? const Icon(
                        Icons.key,
                        color: Colors.black38,
                      )
                    : const Icon(
                        Icons.key_off,
                        color: Colors.black38,
                      ),
              )
            : const SizedBox(),
      ),
      obscureText: widget.obscureText,
    );
  }
}

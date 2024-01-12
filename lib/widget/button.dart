// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoxButton extends StatefulWidget {
  const BoxButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.loading,
  }) : super(key: key);

  final text;
  final bool loading;
  final void Function()? onTap;

  @override
  State<BoxButton> createState() => BoxButtonState();
}

class BoxButtonState extends State<BoxButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(color: Color.fromARGB(255, 29, 39, 95)),
        child: Center(
          child: widget.loading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  widget.text,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}

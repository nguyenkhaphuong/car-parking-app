import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')),
          FilteringTextInputFormatter.deny(RegExp(r'^0?\.$')),
        ],
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}

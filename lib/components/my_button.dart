import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.color,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String label;
  final Color? color;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(150, 50),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: color,
      ),
      icon: icon,
    );
  }
}

import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String label;
  final bool isPassword;
  const TextWidget({super.key, required this.label, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: 'enter your $label',
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 92, 92, 93),
          fontSize: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 245, 245, 245),
            width: 2,
          ),
        ),
      ),
    );
  }
}

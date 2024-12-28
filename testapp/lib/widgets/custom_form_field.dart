import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureTex;
  final void Function(String?) onSaved;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    required this.onSaved,
    this.obscureTex = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureTex,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$hintText cannot be empty";
          }
          if (!validationRegEx.hasMatch(value)) {
            if (hintText.toLowerCase() == "password") {
              return "Password must contain at least 8 characters, including uppercase, lowercase, number, and special character.";
            }
            return "Please enter a valid $hintText";
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}

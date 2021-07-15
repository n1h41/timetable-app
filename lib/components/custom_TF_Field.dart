import 'package:flutter/material.dart';

class CustomTFField extends StatelessWidget {
  const CustomTFField({
    Key? key,
    required this.validator,
    required this.emailTEC,
    required this.label,
  }) : super(key: key);

  final String? Function(String? p1) validator;
  final TextEditingController emailTEC;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: label == 'Password' ? true : false,
      validator: validator,
      controller: emailTEC,
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
        filled: true,
        /* fillColor: Colors.white, */
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.maxLines = 1,
  });
  final String hintText;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF9B9B9B),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),

        filled: true,
        fillColor: const Color(0xFFF9FAFA),

        border: bulidBoarder(),
        enabledBorder: bulidBoarder(),
        focusedBorder: bulidBoarder(),
      ),

      onChanged: (value) {
        // Handle text input changes here
      },
    );
  }

  OutlineInputBorder bulidBoarder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFFE6E9E9), width: 1.0),
    );
  }
}

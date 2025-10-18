// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  // final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final TextStyle? style;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    // required this.keyboardType,
    required this.prefixIcon,
    required this.obscureText,
    required this.suffixIcon,
    required this.validator,
    required this.controller,
    required this.labelStyle,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      controller: controller,
      obscureText: obscureText!,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}

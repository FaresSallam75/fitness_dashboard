import 'package:fitness_dashboard/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchTextFormField extends StatelessWidget {
  final String? labelText;
  final TextInputType? keyboardType;
  final IconData? icon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextTheme theme;

  const CustomSearchTextFormField({
    super.key,
    required this.labelText,
    required this.keyboardType,
    required this.icon,
    required this.obscureText,
    required this.suffixIcon,
    required this.validator,
    required this.controller,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText!,
            validator: validator,
            style: theme.headlineSmall!.copyWith(color: MyColors.dark),
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: labelText,
              labelStyle: theme.headlineMedium!.copyWith(color: MyColors.dark),

              suffixIcon: suffixIcon,
            ),
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }
}

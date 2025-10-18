import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? backgroundColor;
  final void Function()? onPressed;
  final String buttonText;
  final TextStyle? style;
  const CustomElevatedButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.buttonText,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(buttonText, style: style),
      ),
    );
  }
}

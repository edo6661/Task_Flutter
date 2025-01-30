import 'package:flutter/material.dart';
import 'package:frontend/ui/utils/types.dart';

class MainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool? obscureText;
  final Validator? validator;
  final int maxLines;
  final bool isEnabled;
  const MainTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.trailingIcon,
      this.leadingIcon,
      this.obscureText,
      this.validator,
      this.maxLines = 1,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: trailingIcon,
        prefixIcon: leadingIcon,
        enabled: isEnabled,
      ),
    );
  }
}

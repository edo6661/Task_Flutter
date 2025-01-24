import 'package:flutter/material.dart';
import 'package:frontend/ui/utils/types.dart';

class MainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool? obscureText;
  final Validator? validator;
  const MainTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.trailingIcon,
    this.leadingIcon,
    this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: trailingIcon,
        prefixIcon: leadingIcon,
      ),
    );
  }
}

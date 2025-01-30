import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/ui/components/main_text.dart';

class MainElevatedButton extends StatelessWidget {
  const MainElevatedButton(
      {super.key,
      this.isLoading = false,
      required this.onPressed,
      required this.text,
      this.bgColor,
      this.width = double.infinity,
      this.height = 46.0,
      this.textColor = Colors.white});
  final bool isLoading;
  final void Function()? onPressed;
  final String text;
  final Color textColor;
  final Color? bgColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: isLoading
              ? WidgetStateProperty.all(Colors.grey)
              : WidgetStateProperty.all(
                  bgColor ?? Theme.of(context).colorScheme.primary),
          minimumSize: WidgetStateProperty.all(Size(width, height)),
        ),
        child: MainText(text: text, extent: Large(), color: textColor));
  }
}

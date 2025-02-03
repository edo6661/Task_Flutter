import 'package:flutter/material.dart';

class CenterColumnContainer extends StatelessWidget {
  const CenterColumnContainer({
    super.key,
    required this.child,
    this.withPaddingHor = true,
    this.isVerticallyCentered = false,
  });

  final Widget child;
  final bool withPaddingHor;
  final bool isVerticallyCentered;

  Widget content() {
    if (withPaddingHor) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget contentBasedOnParam() {
    if (isVerticallyCentered) {
      return Center(
        child: SingleChildScrollView(
          child: content(),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: content(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return contentBasedOnParam();
  }
}

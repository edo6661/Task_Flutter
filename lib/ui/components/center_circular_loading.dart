import 'package:flutter/material.dart';

class CenterCircularLoading extends StatelessWidget {
  const CenterCircularLoading({super.key, this.isAction = true});
  final bool isAction;

  Widget content() {
    return isAction
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return content();
  }
}

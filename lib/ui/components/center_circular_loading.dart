import 'package:flutter/material.dart';

class CenterCircularLoading extends StatelessWidget {
  const CenterCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

extension WidgetSpacing on Widget {
  Widget withSpacing({double bottom = 8}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: this,
    );
  }
}

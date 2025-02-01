import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/main_text.dart';

class EmptyData extends StatefulWidget {
  const EmptyData({super.key, required this.title});

  final String title;

  @override
  State<EmptyData> createState() => _EmptyDataState();
}

class _EmptyDataState extends State<EmptyData> {
  @override
  Widget build(BuildContext context) {
    return CenterColumnContainer(
        isVerticallyCentered: true,
        withPaddingHor: false,
        child: Column(
          children: [
            Image.asset(
              "assets/images/empty_data.png",
            ),
            MainText(
              text: widget.title,
              extent: Large(),
            ),
          ],
        ));
  }
}

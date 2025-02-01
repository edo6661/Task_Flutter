import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descritionText;
  final DateTime dueAt;
  const TaskCard({
    super.key,
    required this.color,
    required this.headerText,
    required this.descritionText,
    required this.dueAt,
  });

  @override
  Widget build(BuildContext context) {
    // nentuin brightness nya itu gelap atau terang
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    // ! EXPANDED itu untuk mengisi sisa ruang yang ada kek flex 1
    return Expanded(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: headerText,
                  extent: Small(),
                  color: textColor,
                  maxLines: 2,
                ),
                MainText(
                  text: descritionText,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  extent: ExtraSmall(),
                  color: textColor,
                ),
              ],
            ),
          ),
          MainText(
            text: DateFormat('hh:mm a').format(dueAt),
            extent: ExtraSmall(),
            color: textColor.withValues(alpha: 0.9),
          ),
        ],
      ),
    ));
  }
}

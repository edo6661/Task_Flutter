import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';

abstract class BaseText extends StatelessWidget {
  const BaseText({
    super.key,
    required this.text,
    /*
      * Default Value (this.extent = const Small()):

      ! Evaluasi harus dilakukan di compile time. Nilai konstan diperlukan karena Dart harus tahu pasti nilainya sebelum aplikasi berjalan.
      * intinya nilai default harus konstan, otomatis di class dan subclass harus diberikan nilai konstan:
      * - const Extent()
      * - const ExtraSmall()
      * - const Small()
    */
    this.extent = const Small(),
    this.customTextStyle,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.color,
  });
  final Extent extent;
  final TextStyle? customTextStyle;
  final String text;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final Color? color;

  TextStyle? textStyleExtent(BuildContext context) {
    /*
      * switch atau case: 
      ! Evaluasi dilakukan saat runtime, sehingga tidak butuh konstanta.
    */
    switch (extent) {
      case ExtraSmall():
        return Theme.of(context).textTheme.labelMedium;
      case Small():
        return Theme.of(context).textTheme.bodyMedium;
      case Medium():
        return Theme.of(context).textTheme.titleMedium;
      case Large():
        return Theme.of(context).textTheme.headlineMedium;
      case ExtraLarge():
        return Theme.of(context).textTheme.displayMedium;
    }
  }

  TextStyle? textStyle(BuildContext context) {
    return customTextStyle ?? textStyleExtent(context);
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/ui/components/base_text.dart';

class MainText extends BaseText {
  const MainText({
    super.key,
    required super.text,
    /*
      * Default Value (this.extent = const Small()):

      ! Evaluasi harus dilakukan di compile time. Nilai konstan diperlukan karena Dart harus tahu pasti nilainya sebelum aplikasi berjalan.
      * intinya nilai default harus konstan, otomatis di class dan subclass harus diberikan nilai konstan:
      * - const Extent()
      * - const ExtraSmall()
      * - const Small()
    */
    super.extent = const Small(),
    super.customTextStyle,
    super.textAlign = TextAlign.left,
    super.maxLines = 1,
    super.overflow = TextOverflow.ellipsis,
    super.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: textStyle(context)!.copyWith(
          color: color,
        ));
  }
}

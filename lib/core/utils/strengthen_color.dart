import 'package:flutter/material.dart';

// ! memperkuat warna, bisa dengan membuatnya lebih terang atau lebih gelap berdasarkan faktor yang diberikan
Color strengthenColor(Color color, double factor) {
  final hsl = HSLColor.fromColor(color);

  final newLightness = (hsl.lightness * factor).clamp(0.0, 1.0);

  return hsl.withLightness(newLightness).toColor();
}

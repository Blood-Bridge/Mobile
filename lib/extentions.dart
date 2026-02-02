// lib/core/extensions/context_extensions.dart
import 'package:flutter/material.dart';

extension ContextExtentions on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;

  double get textScale => MediaQuery.textScalerOf(this).textScaleFactor;

  // Scale يعتمد على عرض الشاشة
  double _baseScale() {
    final w = width.clamp(320.0, 430.0);
    return w / 390.0;
  }

  double sp(num fontSize) {
    final scaled = (fontSize.toDouble() * _baseScale()) * textScale;
    return scaled.clamp(fontSize.toDouble() * 0.90, fontSize.toDouble() * 1.30);
  }

  double lh(num value) => value.toDouble() * 1.5;
}

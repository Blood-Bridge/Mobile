import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);

  bool get _isPortrait => _size.height > _size.width;

  /// Always treat screen as portrait
  /// If landscape → swap width & height
  double get height => _isPortrait ? _size.height : _size.width;

  double get width => _isPortrait ? _size.width : _size.height;

  /// System text scale (accessibility)
  double get textScale => MediaQuery.textScalerOf(this).textScaleFactor;

  /// Base scale based on design width (390 like iPhone 13)
  double _baseScale() {
    final w = width.clamp(320.0, 430.0);
    return w / 390.0;
  }

  /// Responsive font size
  double sp(num fontSize) {
    final scaled = fontSize.toDouble() * _baseScale() * textScale;

    return scaled.clamp(fontSize.toDouble() * 0.90, fontSize.toDouble() * 1.30);
  }

  /// Line height helper
  double lh(num value) => value.toDouble() * 1.5;
}

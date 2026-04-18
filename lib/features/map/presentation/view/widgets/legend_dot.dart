import 'package:flutter/material.dart';

class LegendDot extends StatelessWidget {
  final Color color;
  const LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

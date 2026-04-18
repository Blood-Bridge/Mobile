import 'package:flutter/material.dart';

class MapMarker extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const MapMarker({
    required this.color,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      scale: isSelected ? 1.08 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(isSelected ? 0.22 : 0.10),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.water_drop_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

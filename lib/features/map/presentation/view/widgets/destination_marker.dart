import 'package:flutter/material.dart';

class DestinationMarker extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const DestinationMarker({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.95), color.withOpacity(0.75)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_pin,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

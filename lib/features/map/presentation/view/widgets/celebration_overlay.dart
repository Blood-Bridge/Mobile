import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (_, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, color: Colors.greenAccent, size: 100),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.arrivedSuccessfully,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PulseDot extends StatelessWidget {
  const PulseDot({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final outerScale = 0.6 + (t * 0.8);
        final outerOpacity = (1.0 - t).clamp(0.0, 1.0);

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: outerOpacity * 0.45,
                child: Transform.scale(
                  scale: outerScale,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2F80ED),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2F80ED).withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// Pulsing concentric-circle animation used while donors are being
/// searched/notified. Purely presentational — driven by an internal
/// AnimationController, no business logic.
class FindingDonorsAnimation extends StatefulWidget {
  const FindingDonorsAnimation({super.key, this.size = 180});

  final double size;

  @override
  State<FindingDonorsAnimation> createState() => _FindingDonorsAnimationState();
}

class _FindingDonorsAnimationState extends State<FindingDonorsAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildRing(delay: 0),
              _buildRing(delay: 0.33),
              _buildRing(delay: 0.66),
              Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: AppColors.primaryForeground, size: 28),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRing({required double delay}) {
    final t = (_pulseController.value + delay) % 1.0;
    final scale = 0.4 + t * 0.6;
    final opacity = (1 - t).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}

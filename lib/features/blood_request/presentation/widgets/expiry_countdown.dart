import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// "This request will expire in MM:SS" footer text.
class ExpiryCountdown extends StatelessWidget {
  const ExpiryCountdown({super.key, required this.remaining});

  final Duration remaining;

  String get _formatted {
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = remaining <= Duration.zero;
    return Text(
      isExpired ? 'This request has expired' : 'This request will expire in $_formatted',
      style: TextStyle(
        color: isExpired ? AppColors.destructive : AppColors.textMuted,
        fontSize: 11,
      ),
      textAlign: TextAlign.center,
    );
  }
}

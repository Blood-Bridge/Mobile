import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String text;
  const ErrorBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70)),
    );
  }
}

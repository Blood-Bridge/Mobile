import 'dart:ui';

import 'package:blood_bridge/features/map/presentation/view/widgets/legend_dot.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  final int withinCount;
  final int km;
  final String infoText;
  final bool hasSelection;
  final bool trackingEnabled;
  final VoidCallback onAccept;
  final VoidCallback onStop;
  final VoidCallback onArrived;

  const BottomPanel({
    required this.withinCount,
    required this.km,
    required this.infoText,
    required this.hasSelection,
    required this.trackingEnabled,
    required this.onAccept,
    required this.onStop,
    required this.onArrived,
  });

  @override
  Widget build(BuildContext context) {
    final isRecipient = HiveHelper.getUserRole() == 'recipient';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: isRecipient
                    ? const [
                        LegendDot(color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Compatible Donor",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ]
                    : const [
                        LegendDot(color: Color(0xFFE58B93)),
                        SizedBox(width: 8),
                        Text("Critical", style: TextStyle(color: Colors.white70)),
                        SizedBox(width: 16),
                        LegendDot(color: Color(0xFFF6B400)),
                        SizedBox(width: 8),
                        Text("Urgent", style: TextStyle(color: Colors.white70)),
                        SizedBox(width: 16),
                        LegendDot(color: Color(0xFF77B47C)),
                        SizedBox(width: 8),
                        Text("Available", style: TextStyle(color: Colors.white70)),
                      ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$withinCount ${isRecipient ? 'donors' : 'requests'} within $km km",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            infoText,
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (hasSelection && !isRecipient)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: trackingEnabled ? null : onAccept,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F80ED),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              trackingEnabled ? "Tracking..." : "Accept",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (trackingEnabled)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onArrived,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF27AE60),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text("Arrived"),
                            ),
                          ),
                      ],
                    ),
                    if (trackingEnabled) ...[
                      const SizedBox(height: 10),
                      IconButton(
                        onPressed: onStop,
                        icon: const Icon(
                          Icons.stop_circle,
                          color: Colors.white70,
                          size: 30,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

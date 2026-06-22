import 'package:blood_bridge/features/emergency/data/repositories/emergency_repository_mock.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:blood_bridge/features/emergency/presentation/views/emergency_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the entire emergency flow (Emergency ->
/// Confirm Emergency -> Finding Donors -> Request Sent).
///
/// Provides a single [EmergencyCubit] above all 4 screens via
/// `Navigator.push`, so the selected blood type and search progress
/// survive navigation between them. Push this widget to start the flow:
///
/// ```dart
/// Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyFlowView()));
/// ```
///
/// Swap `EmergencyRepositoryMock()` for `EmergencyRepositoryImpl()`
/// once the backend endpoints are ready — no other code needs to change.
class EmergencyFlowView extends StatelessWidget {
  const EmergencyFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmergencyCubit(EmergencyRepositoryMock()),
      child: const EmergencyView(),
    );
  }
}

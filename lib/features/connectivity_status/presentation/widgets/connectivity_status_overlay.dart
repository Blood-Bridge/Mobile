import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/connectivity_status/domain/entities/connectivity_status_entity.dart';
import 'package:blood_bridge/features/connectivity_status/presentation/cubit/connectivity_status_cubit.dart';
import 'package:blood_bridge/features/connectivity_status/presentation/widgets/status_screen.dart';

/// Wraps the entire app (place inside `MaterialApp.builder`) and
/// shows a full-screen "No Connection" or "Location Disabled" overlay
/// whenever [ConnectivityStatusCubit] reports a problem, hiding the
/// normal app content underneath until it's resolved.
///
/// Usage in `main.dart`:
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ConnectivityStatusOverlay(child: child!),
///   home: const SettingView(),
/// )
/// ```
///
/// Make sure `ConnectivityStatusCubit` is provided above this widget
/// (e.g. in the `MultiBlocProvider` in `MyApp`) and that `.start()`
/// has been called once.
class ConnectivityStatusOverlay extends StatelessWidget {
  const ConnectivityStatusOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
      builder: (context, state) {
        switch (state.status) {
          case AppStatus.noConnection:
            return StatusScreen(
              icon: Icons.wifi_off,
              title: 'No Connection',
              message: 'Please check your internet connection and try again.',
              primaryActionLabel: 'Retry',
              onPrimaryAction: () => context.read<ConnectivityStatusCubit>().recheck(),
              secondaryActionLabel: 'Cancel Request',
              onSecondaryAction: () {},
            );

          case AppStatus.locationDisabled:
            return StatusScreen(
              icon: Icons.location_off,
              title: 'Location Disabled',
              message: 'Blood Bridge needs location access to find nearby blood donors.',
              primaryActionLabel: 'Enable Location',
              onPrimaryAction: () => context.read<ConnectivityStatusCubit>().openLocationSettings(),
              secondaryActionLabel: 'Cancel Request',
              onSecondaryAction: () {},
            );

          case AppStatus.ok:
            return child;
        }
      },
    );
  }
}

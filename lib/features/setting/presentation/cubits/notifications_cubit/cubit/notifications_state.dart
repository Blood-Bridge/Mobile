import 'package:equatable/equatable.dart';

// ── Keys ─────────────────────────────────────────────
class NotificationsKeys {
  static const String box = 'settings';
  static const String emergencyAlerts = 'emergencyAlerts';
  static const String requestNotifications = 'requestNotifications';
  static const String donationReminders = 'donationReminders';
}

// ── State ─────────────────────────────────────────────
class NotificationsState extends Equatable {
  final bool emergencyAlerts;
  final bool requestNotifications;
  final bool donationReminders;

  const NotificationsState({
    this.emergencyAlerts = true,
    this.requestNotifications = true,
    this.donationReminders = false,
  });

  NotificationsState copyWith({
    bool? emergencyAlerts,
    bool? requestNotifications,
    bool? donationReminders,
  }) {
    return NotificationsState(
      emergencyAlerts: emergencyAlerts ?? this.emergencyAlerts,
      requestNotifications: requestNotifications ?? this.requestNotifications,
      donationReminders: donationReminders ?? this.donationReminders,
    );
  }

  @override
  List<Object?> get props => [
    emergencyAlerts,
    requestNotifications,
    donationReminders,
  ];
}

import 'package:blood_bridge/core/services/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// ── Keys ─────────────────────────────────────────────
// نفس الـ box الموجود في main.dart
class NotificationsKeys {
  static const String box = 'settings'; // أو أي box موجود عندك
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

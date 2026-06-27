// ── Cubit ─────────────────────────────────────────────
import 'package:blood_bridge/core/services/notification_service.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final Box _box;

  NotificationsCubit(this._box)
    : super(
        NotificationsState(
          // نقرأ القيم المحفوظة من Hive
          emergencyAlerts: _box.get(
            NotificationsKeys.emergencyAlerts,
            defaultValue: true,
          ),
          requestNotifications: _box.get(
            NotificationsKeys.requestNotifications,
            defaultValue: true,
          ),
          donationReminders: _box.get(
            NotificationsKeys.donationReminders,
            defaultValue: false,
          ),
        ),
      );

  // ── Emergency Alerts ────────────────────────────────
  Future<void> toggleEmergencyAlerts(bool value) async {
    await _box.put(NotificationsKeys.emergencyAlerts, value);

    if (!value) await NotificationsService.cancel(1); // id خاص بـ emergency

    emit(state.copyWith(emergencyAlerts: value));
  }

  // ── Request Notifications ───────────────────────────
  Future<void> toggleRequestNotifications(bool value) async {
    await _box.put(NotificationsKeys.requestNotifications, value);

    if (!value) await NotificationsService.cancel(2); // id خاص بـ requests

    emit(state.copyWith(requestNotifications: value));
  }

  // ── Donation Reminders ──────────────────────────────
  Future<void> toggleDonationReminders(bool value) async {
    await _box.put(NotificationsKeys.donationReminders, value);

    if (!value) await NotificationsService.cancel(3); // id خاص بـ reminders

    emit(state.copyWith(donationReminders: value));
  }
}

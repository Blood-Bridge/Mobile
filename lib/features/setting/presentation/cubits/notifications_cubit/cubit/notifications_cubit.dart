import 'package:blood_bridge/core/services/notification_service.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final Box _box;

  NotificationsCubit(this._box)
    : super(
        NotificationsState(
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

  // ── Helper: تفعيل الإشعارات ──────────────────────────
  Future<bool> _requestPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      // رفض نهائي — نفتح إعدادات الموبايل
      await openAppSettings();
      return false;
    }

    // أول مرة — نطلب الـ permission
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  // ── Emergency Alerts ────────────────────────────────
  Future<void> toggleEmergencyAlerts(bool value) async {
    if (value) {
      final granted = await _requestPermission();
      if (!granted) return;
      await _box.put(NotificationsKeys.emergencyAlerts, true);
      emit(state.copyWith(emergencyAlerts: true));
    } else {
      await _box.put(NotificationsKeys.emergencyAlerts, false);
      await NotificationsService.cancel(1);
      emit(state.copyWith(emergencyAlerts: false));
      await openAppSettings(); // يفتح إعدادات الموبايل لإقفال الإشعارات
    }
  }

  // ── Request Notifications ───────────────────────────
  Future<void> toggleRequestNotifications(bool value) async {
    if (value) {
      final granted = await _requestPermission();
      if (!granted) return;
      await _box.put(NotificationsKeys.requestNotifications, true);
      emit(state.copyWith(requestNotifications: true));
    } else {
      await _box.put(NotificationsKeys.requestNotifications, false);
      await NotificationsService.cancel(2);
      emit(state.copyWith(requestNotifications: false));
      await openAppSettings();
    }
  }

  // ── Donation Reminders ──────────────────────────────
  Future<void> toggleDonationReminders(bool value) async {
    if (value) {
      final granted = await _requestPermission();
      if (!granted) return;
      await _box.put(NotificationsKeys.donationReminders, true);
      emit(state.copyWith(donationReminders: true));
    } else {
      await _box.put(NotificationsKeys.donationReminders, false);
      await NotificationsService.cancel(3);
      emit(state.copyWith(donationReminders: false));
      await openAppSettings();
    }
  }
}

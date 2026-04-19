import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  NotificationsService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ── Init ─────────────────────────────────────────
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );
  }

  // ── إلغاء كل الإشعارات ───────────────────────────
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── إلغاء إشعار معين ─────────────────────────────
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }
}

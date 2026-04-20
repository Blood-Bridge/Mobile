import 'package:hive/hive.dart';

/// Manages all local storage operations using Hive
/// Handles user data, courses cache and onboarding state

class HiveHelper {
  static const onboardingBox = "ONBOARDING_BOX";
  static const userBox = "USER_BOX";
  static const permissionsBox = "PERMISSIONS";
  static const cachedLocationBox = "CACHED_LOCATION_BOX";
  static const KEY_BOX_APP_LANGUAGE = "KEY_BOX_APP_LANGUAGE";

  /// Sets onboarding completion flag
  static Future<void> setValueInOnboardingBox() async {
    try {
      final box = await Hive.openBox(onboardingBox);
      await box.put(onboardingBox, true);
    } catch (e) {
      throw Exception('Failed to set onboarding value: ${e.toString()}');
    }
  }

  /// Deletes user token
  static Future<void> clearToken() async {
    try {
      final box = await Hive.openBox(userBox);
      await box.delete("token");
    } catch (e) {
      throw Exception('Failed to clear token: ${e.toString()}');
    }
  }

  /// Deletes all user data
  static Future<void> clearUser() async {
    try {
      final box = await Hive.openBox(userBox);
      await box.clear(); // يمسح كل حاجة (token + email + userType)
    } catch (e) {
      throw Exception('Failed to clear user data: ${e.toString()}');
    }
  }

  /// Checks if onboarding was completed
  static bool checkOnBoardingValue() {
    try {
      return Hive.box(onboardingBox).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Saves user token to local storage
  static Future<void> setToken(String? tokenParam) async {
    try {
      final box = await Hive.openBox(userBox);
      await box.put("token", tokenParam);
    } catch (e) {
      throw Exception('Failed to set token: ${e.toString()}');
    }
  }

  static Future<void> setLanguage(String? langCode) async {
    try {
      await Hive.box(KEY_BOX_APP_LANGUAGE).put(KEY_BOX_APP_LANGUAGE, langCode);
    } catch (e) {
      throw Exception("Failed to set language: ${e.toString()}");
    }
  }

  static String? getLanguage() {
    try {
      final value =
          Hive.box(KEY_BOX_APP_LANGUAGE).get(KEY_BOX_APP_LANGUAGE) as String?;
      return value;
    } catch (e) {
      return null;
    }
  }

  /// Retrieves user token from local storage
  static String? getToken() {
    try {
      final box = Hive.box(userBox);
      return box.isNotEmpty ? box.get("token") : null;
    } catch (e) {
      return null;
    }
  }

  //set user email and user type
  static Future<void> setUserRole({
    required String email,
    String? userType,
  }) async {
    try {
      final box = await Hive.openBox(userBox);
      await box.put("email", email);
    } catch (e) {
      throw Exception('Failed to set Email: ${e.toString()}');
    }
  }

  static bool? isLocationGranted() {
    try {
      final box = Hive.box(permissionsBox);
      return box.isNotEmpty ? box.get("locationaccess") : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setLocationAccess({required bool isAccessGranted}) async {
    try {
      final box = await Hive.openBox(permissionsBox);
      await box.put("locationaccess", isAccessGranted);
    } catch (e) {
      throw Exception('Failed to set Location Access: ${e.toString()}');
    }
  }

  static bool? isNotificationGranted() {
    try {
      final box = Hive.box(permissionsBox);
      return box.isNotEmpty ? box.get("notificationaccess") : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setNotificationAccess({
    required bool isAccessGranted,
  }) async {
    try {
      final box = await Hive.openBox(permissionsBox);
      await box.put("notificationaccess", isAccessGranted);
    } catch (e) {
      throw Exception('Failed to set Notification Access: ${e.toString()}');
    }
  }

  //get user email
  static String? getUserEmail() {
    try {
      final box = Hive.box(userBox);
      return box.isNotEmpty ? box.get("email") : null;
    } catch (e) {
      return null;
    }
  }

  //get user role
  static String? getUserRole() {
    try {
      final box = Hive.box(userBox);
      return box.isNotEmpty ? box.get("userType") : null;
    } catch (e) {
      return null;
    }
  }
}

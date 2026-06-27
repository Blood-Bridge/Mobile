import 'package:hive/hive.dart';

/// Manages all local storage operations using Hive
/// Handles user data, courses cache and onboarding state

class HiveHelper {
  static const onboardingBox = "ONBOARDING_BOX";
  static const userBox = "USER_BOX";
  static const permissionsBox = "PERMISSIONS";
  static const cachedLocationBox = "CACHED_LOCATION_BOX";
  static const avilablityBox = "AVILABILITY_BOX";
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

  /// Checks if onboarding was completed
  static bool checkOnBoardingValue() {
    try {
      return Hive.box(onboardingBox).isNotEmpty;
    } catch (e) {
      return false;
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

  static Future<void> setAvailability(bool availability) async {
    try {
      final box = await Hive.openBox(avilablityBox);
      await box.put(avilablityBox, availability);
    } catch (e) {
      throw Exception('Failed to set onboarding value: ${e.toString()}');
    }
  }

  static bool isAvailability() {
    try {
      final box = Hive.box(avilablityBox);
      return box.isNotEmpty ? box.get(avilablityBox) : true;
    } catch (e) {
      return true;
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
      if (userType != null && userType.isNotEmpty) {
        // Normalize to lowercase so all comparisons work regardless of source
        await box.put("userType", userType.toLowerCase());
      }
    } catch (e) {
      throw Exception('Failed to set Email: ${e.toString()}');
    }
  }

  static Future<void> setUserDetails({
    required String name,
    required int age,
  }) async {
    try {
      final box = await Hive.openBox(userBox);
      await box.put("name", name);
      await box.put("Age", age);
    } catch (e) {
      throw Exception('Failed to set Details: ${e.toString()}');
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

  static String? getUserName() {
    try {
      final box = Hive.box(userBox);
      return box.isNotEmpty ? box.get("name") : null;
    } catch (e) {
      return null;
    }
  }

  static String? getUserAge() {
    try {
      final box = Hive.box(userBox);
      return box.isNotEmpty ? box.get("age") : null;
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

  static Future<void> clearUserData() async {
    await Hive.box(userBox).clear();
  }
}

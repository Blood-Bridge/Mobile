import 'package:hive/hive.dart';

/// Manages all local storage operations using Hive
/// Handles user data, courses cache and onboarding state

class HiveHelper {
  static const onboardingBox = "ONBOARDING_BOX";
  static const userBox = "USER_BOX";

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

  /// Saves user token to local storage
  static Future<void> setToken(String? tokenParam) async {
    try {
      final box = await Hive.openBox(userBox);
      await box.put("token", tokenParam);
    } catch (e) {
      throw Exception('Failed to set token: ${e.toString()}');
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
}

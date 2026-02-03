import 'package:hive/hive.dart';

/// Manages all local storage operations using Hive
class HiveHelper {
  // Box names (constants)
  static const String onboardingBoxName = 'onboarding_box';
  static const String userBoxName = 'user_box';

  // Keys
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _tokenKey = 'auth_token';
  static const String _userRoleKey = 'user_role';

  // Cache boxes to avoid reopening them every time
  static Box? _onboardingBox;
  static Box? _userBox;

  /// Initializes Hive boxes (call this once in main.dart after Hive.initFlutter())
  static Future<void> init() async {
    _onboardingBox = await Hive.openBox(onboardingBoxName);
    _userBox = await Hive.openBox(userBoxName);
  }

  /// Call this in main() before runApp()
  /// Example:
  /// await HiveHelper.init();
  /// runApp(MyApp());

  // ────────────────────────────────────────────────
  // Onboarding
  // ────────────────────────────────────────────────

  static Future<void> setOnboardingCompleted() async {
    final box = _onboardingBox ?? await Hive.openBox(onboardingBoxName);
    await box.put(_onboardingCompletedKey, true);
  }

  static bool isOnboardingCompleted() {
    final box = _onboardingBox;
    if (box == null || !box.isOpen) {
      // Fallback if not initialized (should not happen)
      return false;
    }
    return box.get(_onboardingCompletedKey, defaultValue: false) as bool;
  }

  // ────────────────────────────────────────────────
  // Auth Token
  // ────────────────────────────────────────────────

  static Future<void> saveToken(String? token) async {
    final box = _userBox ?? await Hive.openBox(userBoxName);
    await box.put(_tokenKey, token);
  }

  static String? getToken() {
    final box = _userBox;
    if (box == null || !box.isOpen) return null;
    return box.get(_tokenKey) as String?;
  }

  static Future<void> clearToken() async {
    final box = _userBox ?? await Hive.openBox(userBoxName);
    await box.delete(_tokenKey);
  }

  // ────────────────────────────────────────────────
  // User Role (since you use it in Welcome screen)
  // ────────────────────────────────────────────────

  static Future<void> saveUserRole(String role) async {
    // Store as String to avoid enum registration issues
    final box = _userBox ?? await Hive.openBox(userBoxName);
    await box.put(_userRoleKey, role);
  }

  static String? getUserRole() {
    final box = _userBox;
    if (box == null || !box.isOpen) return null;
    return box.get(_userRoleKey) as String?;
  }

  // ────────────────────────────────────────────────
  // Clear all user data (logout / reset)
  // ────────────────────────────────────────────────

  static Future<void> clearUserData() async {
    final userBox = _userBox ?? await Hive.openBox(userBoxName);
    await userBox.clear();
  }

  static Future<void> closeAllBoxes() async {
    if (_onboardingBox?.isOpen ?? false) await _onboardingBox?.close();
    if (_userBox?.isOpen ?? false) await _userBox?.close();
    _onboardingBox = null;
    _userBox = null;
  }
}

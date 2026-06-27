import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/secure_storage_service.dart';
import 'package:hive/hive.dart';

class AppInitializer {
  static Future<void> checkAuthAndClean() async {
    final token = await SecureStorageService.getToken();

    if (token == null || token.isEmpty) {
      await _clearAllLocalData();
    }
  }

  static Future<void> _clearAllLocalData() async {
    HiveHelper.clearUserData();
    await SecureStorageService.clear();

    print("🧹 Local data cleared");
  }
}

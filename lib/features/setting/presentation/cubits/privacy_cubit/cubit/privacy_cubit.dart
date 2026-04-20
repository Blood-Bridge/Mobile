import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  final Box _box;

  PrivacyCubit(this._box)
    : super(
        PrivacyState(
          locationSharing: _box.get(
            PrivacyKeys.locationSharing,
            defaultValue: true,
          ),
          profileVisibility: _box.get(
            PrivacyKeys.profileVisibility,
            defaultValue: true,
          ),
        ),
      );

  // ── Location Sharing ────────────────────────────────
  Future<void> toggleLocationSharing(bool value) async {
    if (value) {
      // اليوزر عايز يفعل — نطلب الـ permission
      final status = await Permission.location.request();

      if (status.isGranted) {
        await _box.put(PrivacyKeys.locationSharing, true);
        emit(state.copyWith(locationSharing: true));
      } else if (status.isPermanentlyDenied) {
        // اليوزر رفض نهائياً — نفتحله إعدادات الموبايل
        await openAppSettings();
        emit(state.copyWith(locationSharing: false));
      } else {
        // رفض مؤقت
        emit(state.copyWith(locationSharing: false));
      }
    } else {
      // اليوزر عايز يقفل — نحفظ في Hive ونفتح إعدادات الموبايل
      await _box.put(PrivacyKeys.locationSharing, false);
      emit(state.copyWith(locationSharing: false));
      // نفتح إعدادات الموبايل عشان يقفل الـ location من هناك
      await openAppSettings();
    }
  }

  // ── Profile Visibility ──────────────────────────────
  Future<void> toggleProfileVisibility(bool value) async {
    await _box.put(PrivacyKeys.profileVisibility, value);
    emit(state.copyWith(profileVisibility: value));
  }
}

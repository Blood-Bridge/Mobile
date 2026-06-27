import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(PermissionsInitial());

  bool isLocationAccessGranted = false;
  bool isNotificationAccessGranted = false;
  bool isEnabled = false;

  Future<void> checkPermission() async {
    final locationStatus = await Permission.location.status;
    final notificationStatus = await Permission.notification.status;

    isLocationAccessGranted = locationStatus.isGranted;
    isNotificationAccessGranted = notificationStatus.isGranted;

    await HiveHelper.setLocationAccess(
      isAccessGranted: isLocationAccessGranted,
    );
    await HiveHelper.setNotificationAccess(
      isAccessGranted: isNotificationAccessGranted,
    );

    isEnabled = isLocationAccessGranted && isNotificationAccessGranted;
    if (isEnabled) {
      emit(PermissionsUpdated());
    } else {
      emit(Permissionsmissing());
    }
  }

  Future<void> grantLocationPermission() async {
    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        await HiveHelper.setLocationAccess(isAccessGranted: true);
        await checkPermission(); // ✅ await
        emit(PermissionsLocationAccessSuccess());
      } else if (status.isPermanentlyDenied) {
        await HiveHelper.setLocationAccess(isAccessGranted: false);
        openAppSettings();

        emit(PermissionsLocationAccessError());
      } else {
        await HiveHelper.setLocationAccess(isAccessGranted: false);
        openAppSettings();
        await checkPermission();
        emit(PermissionsLocationAccessError());
      }
    } catch (_) {
      await HiveHelper.setLocationAccess(isAccessGranted: false);
      emit(PermissionsLocationAccessError());
    }
  }

  Future<void> grantNotificationPermission() async {
    try {
      final status = await Permission.notification.request();

      if (status.isGranted) {
        await HiveHelper.setNotificationAccess(isAccessGranted: true);
        await checkPermission(); // ✅ await
        emit(PermissionsNotificationAccessSuccess());
      } else if (status.isPermanentlyDenied) {
        await HiveHelper.setNotificationAccess(isAccessGranted: false);
        emit(PermissionsNotificationAccessError());
      } else {
        await HiveHelper.setNotificationAccess(isAccessGranted: false);
        openAppSettings();
        await checkPermission();
        emit(PermissionsNotificationAccessError());
      }
    } catch (_) {
      await HiveHelper.setNotificationAccess(isAccessGranted: false);
      openAppSettings();
      emit(PermissionsNotificationAccessError());
    }
  }
}

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/models/notification_item.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:dio/dio.dart';

part 'app_notifications_state.dart';

class AppNotificationsCubit extends Cubit<AppNotificationsState> {
  AppNotificationsCubit() : super(AppNotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(AppNotificationsLoading());
    try {
      final response = await DioHelper.getData(
        path: 'Notification/get-notifications',
      );

      if (response.statusCode == 200) {
        final dynamic dataField = response.data?['data'];

        List<dynamic> rawItems = [];

        if (dataField is Map) {
          rawItems = dataField['items'] as List<dynamic>? ?? [];
        } else if (dataField is List) {
          rawItems = dataField;
        }

        final items = rawItems
            .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(AppNotificationsLoaded(items));
      } else {
        emit(
          AppNotificationsError(
            response.data?['message'] ?? 'Failed to load notifications',
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        AppNotificationsError(
          e.response?.data?['message'] ?? 'Failed to load notifications',
        ),
      );
    } catch (e) {
      emit(AppNotificationsError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await DioHelper.patchData(path: 'Notification/mark-all-as-read');
      fetchNotifications(); // Refresh after marking as read
    } catch (_) {
      // Best-effort
    }
  }
}

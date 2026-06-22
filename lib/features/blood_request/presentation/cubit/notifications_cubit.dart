import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/blood_request/domain/repositories/blood_request_repository.dart';
import 'package:blood_bridge/features/blood_request/presentation/cubit/notifications_state.dart';

/// Loads and manages the notifications feed (blood requests, accepted
/// requests, donation reminders).
///
/// Named [RequestNotificationsCubit] to avoid clashing with the
/// existing `NotificationsCubit` in `features/setting` (which handles
/// notification *preferences*, not the feed itself).
class RequestNotificationsCubit extends Cubit<NotificationsState> {
  RequestNotificationsCubit(this._repository) : super(const NotificationsInitial());

  final BloodRequestRepository _repository;

  Future<void> loadNotifications() async {
    emit(const NotificationsLoading());
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError('Failed to load notifications: $e'));
    }
  }

  Future<void> clearAll() async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    try {
      await _repository.markAllNotificationsRead();
      emit(const NotificationsLoaded([]));
    } catch (_) {
      // Keep current list if clearing fails.
    }
  }
}

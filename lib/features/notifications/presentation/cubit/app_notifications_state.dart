part of 'app_notifications_cubit.dart';

sealed class AppNotificationsState {
  const AppNotificationsState();
}

final class AppNotificationsInitial extends AppNotificationsState {}

final class AppNotificationsLoading extends AppNotificationsState {}

final class AppNotificationsLoaded extends AppNotificationsState {
  final List<NotificationItem> notifications;
  const AppNotificationsLoaded(this.notifications);
}

final class AppNotificationsError extends AppNotificationsState {
  final String error;
  const AppNotificationsError(this.error);
}

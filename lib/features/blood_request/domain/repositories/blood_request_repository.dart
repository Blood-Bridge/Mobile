import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';

/// Contract for fetching a single request's details, responding to
/// it (accept/decline), and managing the notifications feed.
///
/// Implemented by [BloodRequestRepositoryMock] (hardcoded, used now)
/// and [BloodRequestRepositoryImpl] (real API, plug in endpoints later).
abstract class BloodRequestRepository {
  Future<BloodRequestEntity> getRequestDetail(String requestId);

  Future<void> respondToRequest({required String requestId, required bool accept});

  Future<List<NotificationEntity>> getNotifications();

  Future<void> markAllNotificationsRead();
}

import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';
import 'package:blood_bridge/features/blood_request/domain/repositories/blood_request_repository.dart';

/// Hardcoded implementation used until the real backend endpoints
/// are wired in.
class BloodRequestRepositoryMock implements BloodRequestRepository {
  final List<NotificationEntity> _notifications = [
    NotificationEntity(
      id: 'ntf_001',
      type: NotificationType.bloodRequest,
      title: 'O+ Blood Needed',
      subtitle: 'City Hospital',
      detail: '0.8 km • 2 min ago',
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
      urgency: RequestUrgency.critical,
    ),
    NotificationEntity(
      id: 'ntf_002',
      type: NotificationType.bloodRequest,
      title: 'O+ Blood Needed',
      subtitle: 'Metro Clinic',
      detail: '1.5 km • 15 min ago',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      urgency: RequestUrgency.urgent,
    ),
    NotificationEntity(
      id: 'ntf_003',
      type: NotificationType.requestAccepted,
      title: 'Request Accepted',
      subtitle: 'You accepted a A+ request at Community Hospital',
      detail: '1 hour ago',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    NotificationEntity(
      id: 'ntf_004',
      type: NotificationType.donationReminder,
      title: 'Donation Reminder',
      subtitle: 'You are now eligible to donate blood again',
      detail: '2 hours ago',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationEntity(
      id: 'ntf_005',
      type: NotificationType.bloodRequest,
      title: 'O+ Blood Needed',
      subtitle: 'General Hospital',
      detail: '3.2 km • 3 hours ago',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      urgency: RequestUrgency.normal,
    ),
  ];

  @override
  Future<BloodRequestEntity> getRequestDetail(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return BloodRequestEntity(
      id: requestId,
      bloodType: 'O+',
      ward: 'Emergency Ward',
      hospitalName: 'City Hospital',
      distanceKm: 0.8,
      requestedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      quantityUnits: 2,
      urgency: RequestUrgency.critical,
      location: 'City Hospital',
      expiresAt: DateTime.now().add(const Duration(minutes: 4, seconds: 58)),
    );
  }

  @override
  Future<void> respondToRequest({required String requestId, required bool accept}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // No-op for mock: a real backend would record the donor's response.
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }
}

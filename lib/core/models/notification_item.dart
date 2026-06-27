class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['notificationId'] as int? ?? json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

class RecommendationModel {
  final String bestDay;
  final int bestHour;

  const RecommendationModel({
    required this.bestDay,
    required this.bestHour,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      bestDay: json['bestDay'] as String? ?? 'N/A',
      bestHour: json['bestHour'] as int? ?? 12,
    );
  }

  String get formattedHour {
    if (bestHour == 0) return '12:00 AM';
    if (bestHour == 12) return '12:00 PM';
    if (bestHour > 12) return '${bestHour - 12}:00 PM';
    return '$bestHour:00 AM';
  }
}

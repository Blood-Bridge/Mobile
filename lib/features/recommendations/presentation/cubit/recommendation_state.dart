import 'package:blood_bridge/features/recommendations/data/models/recommendation_model.dart';

sealed class RecommendationState {
  const RecommendationState();
}

final class RecommendationInitial extends RecommendationState {}

final class RecommendationLoading extends RecommendationState {}

final class RecommendationLoaded extends RecommendationState {
  final RecommendationModel recommendation;
  const RecommendationLoaded(this.recommendation);
}

final class RecommendationError extends RecommendationState {
  final String message;
  const RecommendationError(this.message);
}

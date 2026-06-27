import 'package:blood_bridge/features/matching/data/models/match_donor_model.dart';

sealed class MatchState {
  const MatchState();
}

final class MatchInitial extends MatchState {}

final class MatchLoading extends MatchState {}

final class MatchSuccess extends MatchState {
  final List<MatchDonorModel> matchedDonors;
  const MatchSuccess(this.matchedDonors);
}

final class MatchError extends MatchState {
  final String message;
  const MatchError(this.message);
}

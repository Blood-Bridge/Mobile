import 'package:equatable/equatable.dart';
import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';

abstract class RequestDetailState extends Equatable {
  const RequestDetailState();

  @override
  List<Object?> get props => [];
}

class RequestDetailInitial extends RequestDetailState {
  const RequestDetailInitial();
}

class RequestDetailLoading extends RequestDetailState {
  const RequestDetailLoading();
}

class RequestDetailLoaded extends RequestDetailState {
  const RequestDetailLoaded({
    required this.request,
    required this.remaining,
    this.isResponding = false,
  });

  final BloodRequestEntity request;

  /// Time left before the offer expires, ticked down by the cubit.
  final Duration remaining;

  final bool isResponding;

  bool get isExpired => remaining <= Duration.zero;

  RequestDetailLoaded copyWith({
    BloodRequestEntity? request,
    Duration? remaining,
    bool? isResponding,
  }) {
    return RequestDetailLoaded(
      request: request ?? this.request,
      remaining: remaining ?? this.remaining,
      isResponding: isResponding ?? this.isResponding,
    );
  }

  @override
  List<Object?> get props => [request, remaining, isResponding];
}

class RequestDetailError extends RequestDetailState {
  const RequestDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Emitted once after the donor accepts or declines, so the UI can
/// navigate away / show confirmation.
class RequestDetailResponded extends RequestDetailState {
  const RequestDetailResponded(this.accepted);

  final bool accepted;

  @override
  List<Object?> get props => [accepted];
}

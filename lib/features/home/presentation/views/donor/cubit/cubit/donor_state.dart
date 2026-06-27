part of 'donor_cubit.dart';

@immutable
sealed class DonorState {}

class DonorInitial extends DonorState {}

class DonorsLoading extends DonorState {}

class DonorsSuccess extends DonorState {
  final dynamic donors;
  DonorsSuccess(this.donors);
}

class DonorsError extends DonorState {
  final String message;
  DonorsError(this.message);
}

class MapError extends DonorState {
  final String message;
  MapError(this.message);
}

/// Emitted when the donor successfully accepts a request.
/// Carries the requestId so the UI can switch to the Deliveries tab.
class DonorAccepted extends DonorState {
  final int requestId;
  DonorAccepted(this.requestId);
}

class DonorDeleteSuccess extends DonorState {}

// ── Accepted-Requests lifecycle states ──────────────────────────────────────

class DonorAcceptedRequestsLoading extends DonorState {}

class DonorAcceptedRequestsLoaded extends DonorState {
  final List<BloodRequestModel> requests;
  DonorAcceptedRequestsLoaded(this.requests);
}

class DonorAcceptedRequestsError extends DonorState {
  final String message;
  DonorAcceptedRequestsError(this.message);
}

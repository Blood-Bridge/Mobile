part of 'donor_cubit.dart';

@immutable
sealed class DonorState {}

class DonorInitial extends DonorState {}

class DonorsLoading extends DonorState {}

class DonorsSuccess extends DonorState {
  final dynamic donors; // يفضل يكون dynamic
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

class DonorAccepted extends DonorState {
  final int requestId;
  DonorAccepted(this.requestId);
}

class DonorDeleteSuccess extends DonorState {}

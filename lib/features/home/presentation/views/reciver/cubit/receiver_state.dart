part of 'receiver_cubit.dart';

sealed class ReceiverState {
  const ReceiverState();
}

final class ReceiverInitial extends ReceiverState {}

final class ReceiverLoading extends ReceiverState {}

final class ReceiverLoaded extends ReceiverState {
  final List<BloodRequestModel> requests;
  const ReceiverLoaded(this.requests);
}

final class ReceiverSubmitSuccess extends ReceiverState {
  final int requestId;
  final String detectedBloodType;
  final String urgencyLevel;
  const ReceiverSubmitSuccess({
    required this.requestId,
    required this.detectedBloodType,
    required this.urgencyLevel,
  });
}

final class ReceiverCancelSuccess extends ReceiverState {
  final int requestId;
  const ReceiverCancelSuccess(this.requestId);
}

final class ReceiverConfirmDetectionSuccess extends ReceiverState {}

final class ReceiverError extends ReceiverState {
  final String message;
  const ReceiverError(this.message);
}

final class ReceiverSuccess extends ReceiverState {
  final dynamic data;
  const ReceiverSuccess(this.data);
}

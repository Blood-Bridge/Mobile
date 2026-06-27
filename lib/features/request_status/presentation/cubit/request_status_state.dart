import 'package:blood_bridge/features/request_status/data/models/request_status_model.dart';

sealed class RequestStatusState {
  const RequestStatusState();
}

final class RequestStatusInitial extends RequestStatusState {}

final class RequestStatusLoading extends RequestStatusState {}

final class RequestStatusLoaded extends RequestStatusState {
  final RequestStatusModel requestStatus;
  const RequestStatusLoaded(this.requestStatus);
}

final class RequestStatusError extends RequestStatusState {
  final String message;
  const RequestStatusError(this.message);
}

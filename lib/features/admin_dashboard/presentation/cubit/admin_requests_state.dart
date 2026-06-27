import 'package:blood_bridge/core/models/blood_request_model.dart';

sealed class AdminRequestsState {
  const AdminRequestsState();
}

final class AdminRequestsInitial extends AdminRequestsState {}

final class AdminRequestsLoading extends AdminRequestsState {}

final class AdminRequestsLoaded extends AdminRequestsState {
  final List<BloodRequestModel> requests;
  final int pageNumber;
  final int totalPages;

  const AdminRequestsLoaded({
    required this.requests,
    required this.pageNumber,
    required this.totalPages,
  });
}

final class AdminRequestsError extends AdminRequestsState {
  final String message;
  const AdminRequestsError(this.message);
}

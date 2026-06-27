part of 'admin_dashboard_cubit.dart';

@freezed
class AdminDashboardState with _$AdminDashboardState {
  const factory AdminDashboardState({
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(0) int userCount,
    @Default(0) int donorCount,
    @Default(0) int recipientCount,
    @Default(0) int hospitalCount,
    @Default(0) int totalRequests,
    @Default(0) int pendingRequests,
    @Default(0) int completedRequests,
  }) = _AdminDashboardState;

  factory AdminDashboardState.initial() => const AdminDashboardState();
}

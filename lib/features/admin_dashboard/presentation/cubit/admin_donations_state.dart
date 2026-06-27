import 'package:blood_bridge/features/donations/data/models/donation_model.dart';

sealed class AdminDonationsState {
  const AdminDonationsState();
}

final class AdminDonationsInitial extends AdminDonationsState {}

final class AdminDonationsLoading extends AdminDonationsState {}

final class AdminDonationsLoaded extends AdminDonationsState {
  final List<DonationModel> donations;
  final int pageNumber;
  final int totalPages;

  const AdminDonationsLoaded({
    required this.donations,
    required this.pageNumber,
    required this.totalPages,
  });
}

final class AdminDonationsError extends AdminDonationsState {
  final String message;
  const AdminDonationsError(this.message);
}

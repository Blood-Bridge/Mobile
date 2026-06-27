import 'package:blood_bridge/features/donations/data/models/donation_model.dart';

sealed class DonationsState {
  const DonationsState();
}

final class DonationsInitial extends DonationsState {}

final class DonationsLoading extends DonationsState {}

final class DonationsLoaded extends DonationsState {
  final List<DonationModel> donations;
  const DonationsLoaded(this.donations);
}

final class DonationDetailsLoaded extends DonationsState {
  final DonationModel donation;
  const DonationDetailsLoaded(this.donation);
}

final class DonationCreateSuccess extends DonationsState {}

final class DonationUpdateSuccess extends DonationsState {}

final class DonationDeleteSuccess extends DonationsState {}

final class DonationConfirmSuccess extends DonationsState {}

final class DonationsError extends DonationsState {
  final String message;
  const DonationsError(this.message);
}

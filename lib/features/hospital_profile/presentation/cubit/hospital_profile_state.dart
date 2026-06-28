part of 'hospital_profile_cubit.dart';

@immutable
sealed class HospitalProfileState {}

class HospitalProfileInitial extends HospitalProfileState {}

class HospitalProfileLoading extends HospitalProfileState {}

class HospitalProfileLoaded extends HospitalProfileState {
  final HospitalProfile profile;
  HospitalProfileLoaded(this.profile);
}

class HospitalProfileError extends HospitalProfileState {
  final String message;
  HospitalProfileError(this.message);
}

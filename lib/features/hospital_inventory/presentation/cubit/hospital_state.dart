import 'package:equatable/equatable.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';

abstract class HospitalState extends Equatable {
  const HospitalState();

  @override
  List<Object?> get props => [];
}

class HospitalInitial extends HospitalState {
  const HospitalInitial();
}

class HospitalLoading extends HospitalState {
  const HospitalLoading();
}

class HospitalLoaded extends HospitalState {
  const HospitalLoaded({required this.hospital, this.isSubmittingRequest = false});

  final HospitalEntity hospital;

  /// True while a new blood request is being submitted, so the UI
  /// can disable the "Make New Request" button and show a spinner.
  final bool isSubmittingRequest;

  HospitalLoaded copyWith({HospitalEntity? hospital, bool? isSubmittingRequest}) {
    return HospitalLoaded(
      hospital: hospital ?? this.hospital,
      isSubmittingRequest: isSubmittingRequest ?? this.isSubmittingRequest,
    );
  }

  @override
  List<Object?> get props => [hospital, isSubmittingRequest];
}

class HospitalError extends HospitalState {
  const HospitalError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Emitted briefly after a successful request submission so the UI
/// can show a confirmation (e.g. SnackBar) before returning to
/// [HospitalLoaded].
class HospitalRequestSubmitted extends HospitalState {
  const HospitalRequestSubmitted(this.hospital);

  final HospitalEntity hospital;

  @override
  List<Object?> get props => [hospital];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/repositories/hospital_repository.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/cubit/hospital_state.dart';

/// Manages loading the hospital dashboard and submitting new
/// blood requests.
class HospitalCubit extends Cubit<HospitalState> {
  HospitalCubit(this._repository) : super(const HospitalInitial());

  final HospitalRepository _repository;

  Future<void> loadDashboard(String hospitalId) async {
    emit(const HospitalLoading());
    try {
      final hospital = await _repository.getHospitalDashboard(hospitalId);
      emit(HospitalLoaded(hospital: hospital));
    } catch (e) {
      emit(HospitalError('Failed to load hospital data: $e'));
    }
  }

  Future<void> submitBloodRequest({
    required String bloodType,
    required int unitsNeeded,
  }) async {
    final current = state;
    if (current is! HospitalLoaded) return;

    emit(current.copyWith(isSubmittingRequest: true));
    try {
      await _repository.submitBloodRequest(
        hospitalId: current.hospital.id,
        bloodType: bloodType,
        unitsNeeded: unitsNeeded,
      );
      emit(HospitalRequestSubmitted(current.hospital));
      emit(current.copyWith(isSubmittingRequest: false));
    } catch (e) {
      emit(current.copyWith(isSubmittingRequest: false));
    }
  }
}

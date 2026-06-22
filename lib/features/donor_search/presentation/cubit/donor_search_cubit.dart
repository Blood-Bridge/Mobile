import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/donor_search/domain/repositories/donor_search_repository.dart';
import 'package:blood_bridge/features/donor_search/presentation/cubit/donor_search_state.dart';

const _defaultRadiusKm = 5.0;
const _radiusStepKm = 5.0;
const _maxRadiusKm = 25.0;

/// Searches for nearby donors matching a blood type, and lets the
/// user expand the search radius if none are found.
class DonorSearchCubit extends Cubit<DonorSearchState> {
  DonorSearchCubit(this._repository) : super(const DonorSearchLoading());

  final DonorSearchRepository _repository;

  Future<void> search(String bloodType, {double radiusKm = _defaultRadiusKm}) async {
    emit(const DonorSearchLoading());
    try {
      final result = await _repository.searchDonors(bloodType: bloodType, radiusKm: radiusKm);
      if (result.hasResults) {
        emit(DonorSearchFound(result));
      } else {
        emit(DonorSearchEmpty(bloodType: bloodType, searchRadiusKm: radiusKm));
      }
    } catch (e) {
      emit(DonorSearchError('Failed to search donors: $e'));
    }
  }

  /// Expands the search radius (capped at [_maxRadiusKm]) and retries.
  Future<void> expandSearchArea() async {
    final current = state;
    if (current is! DonorSearchEmpty) return;

    final newRadius = (current.searchRadiusKm + _radiusStepKm).clamp(0, _maxRadiusKm).toDouble();
    emit(current.copyWith(isExpanding: true));

    try {
      final result = await _repository.searchDonors(bloodType: current.bloodType, radiusKm: newRadius);
      if (result.hasResults) {
        emit(DonorSearchFound(result));
      } else {
        emit(current.copyWith(searchRadiusKm: newRadius, isExpanding: false));
      }
    } catch (e) {
      emit(current.copyWith(isExpanding: false));
    }
  }
}

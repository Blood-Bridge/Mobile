import 'package:equatable/equatable.dart';
import 'package:blood_bridge/features/donor_search/domain/entities/donor_search_result_entity.dart';

abstract class DonorSearchState extends Equatable {
  const DonorSearchState();

  @override
  List<Object?> get props => [];
}

class DonorSearchLoading extends DonorSearchState {
  const DonorSearchLoading();
}

class DonorSearchEmpty extends DonorSearchState {
  const DonorSearchEmpty({required this.bloodType, required this.searchRadiusKm, this.isExpanding = false});

  final String bloodType;
  final double searchRadiusKm;
  final bool isExpanding;

  DonorSearchEmpty copyWith({double? searchRadiusKm, bool? isExpanding}) {
    return DonorSearchEmpty(
      bloodType: bloodType,
      searchRadiusKm: searchRadiusKm ?? this.searchRadiusKm,
      isExpanding: isExpanding ?? this.isExpanding,
    );
  }

  @override
  List<Object?> get props => [bloodType, searchRadiusKm, isExpanding];
}

class DonorSearchFound extends DonorSearchState {
  const DonorSearchFound(this.result);

  final DonorSearchResultEntity result;

  @override
  List<Object?> get props => [result];
}

class DonorSearchError extends DonorSearchState {
  const DonorSearchError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

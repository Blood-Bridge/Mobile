import 'package:blood_bridge/features/donor_search/domain/entities/donor_search_result_entity.dart';

/// Contract for searching nearby donors matching a blood type, and
/// expanding the search radius if none are found.
///
/// Implemented by [DonorSearchRepositoryMock] (hardcoded, used now)
/// and [DonorSearchRepositoryImpl] (real API, plug in endpoints later).
abstract class DonorSearchRepository {
  Future<DonorSearchResultEntity> searchDonors({
    required String bloodType,
    required double radiusKm,
  });
}

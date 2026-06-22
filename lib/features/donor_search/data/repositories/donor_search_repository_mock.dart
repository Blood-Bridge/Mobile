import 'package:blood_bridge/features/donor_search/domain/entities/donor_search_result_entity.dart';
import 'package:blood_bridge/features/donor_search/domain/repositories/donor_search_repository.dart';

/// Hardcoded implementation used until the real backend endpoints
/// are wired in. Always returns no donors at the initial radius, and
/// some donors once the radius is expanded — useful for demoing the
/// "Expand Search Area" flow.
class DonorSearchRepositoryMock implements DonorSearchRepository {
  @override
  Future<DonorSearchResultEntity> searchDonors({
    required String bloodType,
    required double radiusKm,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final found = radiusKm > 5 ? 3 : 0;
    return DonorSearchResultEntity(donorsFound: found, searchRadiusKm: radiusKm);
  }
}

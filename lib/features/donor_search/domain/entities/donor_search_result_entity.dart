/// Result of a nearby-donor search.
class DonorSearchResultEntity {
  const DonorSearchResultEntity({
    required this.donorsFound,
    required this.searchRadiusKm,
  });

  final int donorsFound;
  final double searchRadiusKm;

  bool get hasResults => donorsFound > 0;
}

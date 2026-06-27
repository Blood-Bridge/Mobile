import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

class MapCacheService {
  static const String _boxName = HiveHelper.cachedLocationBox;
  static const String _latKey = 'last_lat';
  static const String _lngKey = 'last_lng';
  static const String _tsKey = 'last_location_ts';

  Box? _box;

  Future<void> init() async {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
    } else {
      _box = await Hive.openBox(_boxName);
    }
  }

  LatLng? readCachedLocation() {
    final box = _box;
    if (box == null) return null;

    final lat = box.get(_latKey);
    final lng = box.get(_lngKey);

    if (lat == null || lng == null) return null;

    return LatLng((lat as num).toDouble(), (lng as num).toDouble());
  }

  Future<void> saveCachedLocation(LatLng loc) async {
    final box = _box;
    if (box == null) return;

    await box.put(_latKey, loc.latitude);
    await box.put(_lngKey, loc.longitude);
    await box.put(_tsKey, DateTime.now().millisecondsSinceEpoch);
  }
}

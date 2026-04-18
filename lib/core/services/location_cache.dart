import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

class LocationCache {
  static const _boxName = HiveHelper.cachedLocationBox;
  static const _latKey = 'last_lat';
  static const _lngKey = 'last_lng';
  static const _tsKey = 'last_location_ts';

  static Box get _box => Hive.box(_boxName);

  static Future<void> save(LatLng loc) async {
    await _box.put(_latKey, loc.latitude);
    await _box.put(_lngKey, loc.longitude);
    await _box.put(_tsKey, DateTime.now().millisecondsSinceEpoch);
  }

  static LatLng? read() {
    final lat = _box.get(_latKey);
    final lng = _box.get(_lngKey);
    if (lat == null || lng == null) return null;
    return LatLng((lat as num).toDouble(), (lng as num).toDouble());
  }

  static DateTime? readTimestamp() {
    final ts = _box.get(_tsKey);
    if (ts == null) return null;
    return DateTime.fromMillisecondsSinceEpoch((ts as num).toInt());
  }
}

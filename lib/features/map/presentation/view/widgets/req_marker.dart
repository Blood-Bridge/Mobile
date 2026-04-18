import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ReqMarker {
  final String id;
  final LatLng point;
  final Color color;
  final String type;

  const ReqMarker(this.id, this.point, this.color, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ReqMarker && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

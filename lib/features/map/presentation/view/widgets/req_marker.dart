import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ReqMarker {
  final String id;
  final LatLng point;
  final Color color;
  final String type;
  final String? phone; // ← أضف هذا
  final String? bloodType;
  final String title;
  final String name;
  const ReqMarker(
    this.id,
    this.point,
    this.color,
    this.type, {
    this.phone,
    this.bloodType,
    this.title = '',
    this.name = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ReqMarker && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

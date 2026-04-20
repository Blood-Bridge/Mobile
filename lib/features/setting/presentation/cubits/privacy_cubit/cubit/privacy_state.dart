import 'package:equatable/equatable.dart';

// ── Keys ─────────────────────────────────────────────
class PrivacyKeys {
  static const String locationSharing = 'locationSharing';
  static const String profileVisibility = 'profileVisibility';
}

// ── State ─────────────────────────────────────────────
class PrivacyState extends Equatable {
  final bool locationSharing;
  final bool profileVisibility;

  const PrivacyState({
    this.locationSharing = true,
    this.profileVisibility = true,
  });

  PrivacyState copyWith({bool? locationSharing, bool? profileVisibility}) {
    return PrivacyState(
      locationSharing: locationSharing ?? this.locationSharing,
      profileVisibility: profileVisibility ?? this.profileVisibility,
    );
  }

  @override
  List<Object?> get props => [locationSharing, profileVisibility];
}

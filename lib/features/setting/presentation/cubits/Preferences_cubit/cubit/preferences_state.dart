import 'package:equatable/equatable.dart';

// ── Keys ─────────────────────────────────────────────
class PreferencesKeys {
  static const String darkMode = 'darkMode';
  static const String searchRadius = 'searchRadius';
}

// ── State ─────────────────────────────────────────────
class PreferencesState extends Equatable {
  final bool darkMode;
  final double searchRadius;

  const PreferencesState({this.darkMode = true, this.searchRadius = 5.0});

  PreferencesState copyWith({bool? darkMode, double? searchRadius}) {
    return PreferencesState(
      darkMode: darkMode ?? this.darkMode,
      searchRadius: searchRadius ?? this.searchRadius,
    );
  }

  @override
  List<Object?> get props => [darkMode, searchRadius];
}

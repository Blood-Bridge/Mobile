import 'package:blood_bridge/features/setting/presentation/cubits/Preferences_cubit/cubit/preferences_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class PreferencesCubit extends Cubit<PreferencesState> {
  final Box _box;

  PreferencesCubit(this._box)
    : super(
        PreferencesState(
          darkMode: _box.get(PreferencesKeys.darkMode, defaultValue: true),
          searchRadius: _box.get(
            PreferencesKeys.searchRadius,
            defaultValue: 5.0,
          ),
        ),
      );

  // ── Dark Mode ────────────────────────────────────────
  Future<void> toggleDarkMode(bool value) async {
    await _box.put(PreferencesKeys.darkMode, value);
    emit(state.copyWith(darkMode: value));
  }

  // ── Search Radius ────────────────────────────────────
  Future<void> updateSearchRadius(double value) async {
    await _box.put(PreferencesKeys.searchRadius, value);
    emit(state.copyWith(searchRadius: value));
  }
}

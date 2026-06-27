import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit() : super(const PrivacyState());

  void toggleLocationSharing(bool value) =>
      emit(state.copyWith(locationSharing: value));

  void toggleProfileVisibility(bool value) =>
      emit(state.copyWith(profileVisibility: value));
}

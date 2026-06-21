import 'package:equatable/equatable.dart';
import 'package:blood_bridge/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state before the profile has been requested.
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Profile is being fetched.
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Profile loaded successfully.
///
/// [isUpdating] is true while a preference toggle request is in flight,
/// letting the UI show a small inline indicator without losing the
/// current data.
class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.profile, this.isUpdating = false});

  final ProfileEntity profile;
  final bool isUpdating;

  ProfileLoaded copyWith({ProfileEntity? profile, bool? isUpdating}) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [profile, isUpdating];
}

/// Profile failed to load.
class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

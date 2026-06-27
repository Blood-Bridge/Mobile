sealed class SwitchRoleState {
  const SwitchRoleState();
}

final class SwitchRoleInitial extends SwitchRoleState {}

final class SwitchRoleLoading extends SwitchRoleState {}

final class SwitchRoleSuccess extends SwitchRoleState {
  final String message;
  const SwitchRoleSuccess(this.message);
}

final class SwitchRoleError extends SwitchRoleState {
  final String message;
  const SwitchRoleError(this.message);
}

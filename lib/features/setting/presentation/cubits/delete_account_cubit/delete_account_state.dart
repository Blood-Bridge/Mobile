sealed class DeleteAccountState {
  const DeleteAccountState();
}

final class DeleteAccountInitial extends DeleteAccountState {}

final class DeleteAccountLoading extends DeleteAccountState {}

final class DeleteAccountSuccess extends DeleteAccountState {}

final class DeleteAccountError extends DeleteAccountState {
  final String message;
  const DeleteAccountError(this.message);
}

part of 'permissions_cubit.dart';

@immutable
abstract class PermissionsState {}

class PermissionsInitial extends PermissionsState {}

class PermissionsUpdated extends PermissionsState {}

class Permissionsmissing extends PermissionsState {}

class PermissionsLocationAccessSuccess extends PermissionsState {}

class PermissionsLocationAccessError extends PermissionsState {}

class PermissionsNotificationAccessSuccess extends PermissionsState {}

class PermissionsNotificationAccessError extends PermissionsState {}

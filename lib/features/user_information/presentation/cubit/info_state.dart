part of 'info_cubit.dart';

@immutable
abstract class InfoState {}

class InfoInitial extends InfoState {}

class Update extends InfoState {}

class SimpleUpdate extends InfoState {}

class Loading extends InfoState {}

class UnderAge extends InfoState {}

final class WrongData extends InfoState {
  final String message;

  WrongData(this.message);
}

class Success extends InfoState {}

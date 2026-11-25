part of 'developer_cubit.dart';

abstract class DeveloperState {}

class DeveloperInitial extends DeveloperState {}

class DeveloperAuthSuccess extends DeveloperState {}

class DeveloperAuthFailed extends DeveloperState {
  final String message;
  DeveloperAuthFailed(this.message);
}

class DeveloperEnvironmentSelected extends DeveloperState {
  final String environment;
  DeveloperEnvironmentSelected(this.environment);
}

import 'package:equatable/equatable.dart';

base class AppStatus extends Equatable {
  final int appStatus;

  const AppStatus({required this.appStatus});

  @override
  List<Object> get props => [appStatus];
}

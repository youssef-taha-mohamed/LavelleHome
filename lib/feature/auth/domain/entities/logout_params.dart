import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

base class LogoutParameters extends Equatable {
  const LogoutParameters({
    required this.fcmToken,
    required this.platform,
  });

  final String fcmToken;
  final TargetPlatform platform;

  @override
  List<Object> get props {
    return <Object>[
      fcmToken,
      platform,
    ];
  }
}

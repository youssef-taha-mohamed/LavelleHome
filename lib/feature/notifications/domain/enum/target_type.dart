import 'package:flutter/material.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';

enum TargetType {
  system(id: 1, value: 'System'),
  security(id: 2, value: 'Security'),
  course(id: 3, value: 'Course'),
  assignment(id: 4, value: 'Assignment'),
  feedBack(id: 5, value: 'Feedback'),
  payment(id: 6, value: 'Payment'),
  subscription(id: 7, value: 'Subscription'),
  family(id: 8, value: 'Family'),
  contactUs(id: 9, value: 'ContactUs');

  const TargetType({required this.id, required this.value});

  final int id;
  final String value;

  static TargetType fromId(int id) {
    return values.firstWhere((element) => element.id == id);
  }

  static TargetType fromValue(String value) {
    return values.firstWhere((element) => element.value == value);
  }

  Color get color {
    switch (this) {
      case TargetType.payment:
        return MyColors.green;
      case TargetType.subscription:
        return MyColors.yellow2;
      case TargetType.security:
        return MyColors.customRed;
      case TargetType.course:
        return MyColors.color3;
      case TargetType.assignment:
        return const Color(0xFF9C27B0);
      case TargetType.feedBack:
        return const Color(0xFFFF9800);
      case TargetType.contactUs:
        return const Color(0xFF00BCD4);
      case TargetType.system:
        return const Color(0xFF607D8B);
      case TargetType.family:
        return MyColors.appGreen;
    }
  }

  IconData get icon {
    switch (this) {
      case TargetType.payment:
        return Icons.check_circle_rounded;
      case TargetType.subscription:
        return Icons.card_membership_rounded;
      case TargetType.security:
        return Icons.shield_outlined;
      case TargetType.course:
        return Icons.school_rounded;
      case TargetType.assignment:
        return Icons.assignment_rounded;
      case TargetType.feedBack:
        return Icons.rate_review_rounded;
      case TargetType.contactUs:
        return Icons.contact_support_rounded;
      case TargetType.system:
        return Icons.settings_rounded;
      case TargetType.family:
        return Icons.people_rounded;
    }
  }

  String getButtonTitle(BuildContext context) {
    switch (this) {
      case TargetType.course:
      case TargetType.subscription:
        return context.l10n.view_course;
      case TargetType.assignment:
        return context.l10n.view_assignment;
      case TargetType.payment:
        return context.l10n.view_order_details;
      case TargetType.feedBack:
        return context.l10n.view_feedback;
      case TargetType.contactUs:
        return context.l10n.contact_support_;
      case TargetType.family:
        return context.l10n.view_family;
      case TargetType.security:
        return context.l10n.view_security_details;
      case TargetType.system:
        return context.l10n.view_details;
    }
  }

  String buttonTitle(BuildContext context) => getButtonTitle(context);
}

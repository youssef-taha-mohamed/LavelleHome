// المسار: lib/feature/laundry/domain/laundry.dart
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;

/// فئات الخدمات على الرئيسية. توفّر كل مغسلة لكل فئة يعتمد على المغسلة نفسها.
enum LaundryServiceType { washing, ironing, dryCleaning, carpet }

/// حالة المغسلة. unknown = لا توجد بيانات مواعيد، لا نعرض شيئاً ولا نخترع.
enum LaundryStatus { open, closed, unavailable, unknown }

extension LaundryServiceTypeX on LaundryServiceType {
  IconData get icon {
    switch (this) {
      case LaundryServiceType.washing:
        return Icons.local_laundry_service_rounded;
      case LaundryServiceType.ironing:
        return Icons.iron_rounded;
      case LaundryServiceType.dryCleaning:
        return Icons.dry_cleaning_rounded;
      case LaundryServiceType.carpet:
        return Icons.texture_rounded;
    }
  }
}

/// نموذج المغسلة كما يحتاجه الكارت. كل الحقول الاختيارية قد تكون غير متوفرة
/// من الـ backend، والواجهة تتعامل مع غيابها بإخفائها (بدون قيم مخترعة).
class Laundry {
  final String id;
  final String name;
  final String? logoUrl;
  final double? distanceKm;
  final double? rating;
  final int? ratingCount;
  final List<LaundryServiceType> services;
  final double? startingPrice;
  final LaundryStatus status;

  const Laundry({
    required this.id,
    required this.name,
    this.logoUrl,
    this.distanceKm,
    this.rating,
    this.ratingCount,
    this.services = const [],
    this.startingPrice,
    this.status = LaundryStatus.unknown,
  });
}

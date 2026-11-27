// المسار: lib/feature/laundry/domain/laundry.dart
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import '../../../address/domain/entities/address.dart' show GeoPoint;

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

class Laundry {
  final String id;
  final String name;
  final String? area; // اسم المنطقة (مدينتي، الشروق...) ويدخل في البحث
  final String? logoUrl;
  final GeoPoint? location;
  final double? distanceKm;
  final double? rating;
  final int? ratingCount;
  final List<LaundryServiceType> services;
  final double? startingPrice;
  final LaundryStatus status;

  const Laundry({
    required this.id,
    required this.name,
    this.area,
    this.logoUrl,
    this.distanceKm,
    this.rating,
    this.ratingCount,
    this.services = const [],
    this.startingPrice,
    this.status = LaundryStatus.unknown,
    this.location,
  });
}

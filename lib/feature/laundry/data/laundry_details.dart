import 'package:flutter/material.dart' show TimeOfDay;
import '../../address/domain/entities/address.dart';
import 'module/laundry_model.dart';

/// وحدة التسعير. القائمة مبدئية (قطعة/كيلو/متر) وتنتظر تأكيد نماذج التسعير الفعلية.
enum PricingUnit { piece, kg, squareMeter }

/// نوع الخدمة بالنسبة للمواصلة: ملابس أو سجاد (التنظيف الجاف يندرج تحت الملابس).
/// الطلب قد يضم النوعين معاً، والمغسلة تحدد وسيلة الاستلام المناسبة من الأنواع الموجودة فيه.
enum OrderKind { clothes, carpet }

/// طريقة إنهاء الكي للقطعة: على علّاقة أو مطوية
enum GarmentFinish { hanging, folded }

class PriceItem {
  final String name;
  final double price;
  final PricingUnit unit;

  /// الاختيار الافتراضي للقطعة (مثلاً الجاكيت والبالطو والبنطلون: تعليق).
  /// يظهر كافتراضي ويستطيع العميل تغييره. null = لا افتراضي.
  final GarmentFinish? defaultFinish;

  const PriceItem({
    required this.name,
    required this.price,
    this.unit = PricingUnit.piece,
    this.defaultFinish,
  });
}

/// مجموعة خدمة (غسيل، كي، غسيل وكي، تنظيف جاف، سجاد، أو أي خدمة أخرى).
/// الاسم يأتي من المغسلة نفسها. [type] اختياري لتحديد الأيقونة فقط.
class ServiceGroup {
  final String id;
  final String name;
  final LaundryServiceType? type;
  final List<PriceItem> items;

  /// يحدد نوع الطلب الذي تنتمي له هذه الخدمة (ملابس أو سجاد)
  final OrderKind kind;

  /// الخدمة تتضمن كياً، فيختار العميل لكل قطعة: تعليق أم تطبيق
  /// (الغسيل بالقطعة والكي والتنظيف الجاف كلها تُكوى، فيها اختيار)
  final bool hasFinishChoice;

  const ServiceGroup({
    required this.id,
    required this.name,
    this.type,
    this.items = const [],
    this.kind = OrderKind.clothes,
    this.hasFinishChoice = false,
  });
}

/// يوم عمل. weekday: 1=الإثنين ... 7=الأحد (مثل DateTime.weekday).
/// بدون opens/closes = مغلق ذلك اليوم.
class WorkingDay {
  final int weekday;
  final TimeOfDay? opens;
  final TimeOfDay? closes;

  const WorkingDay({required this.weekday, this.opens, this.closes});

  bool get isClosed => opens == null || closes == null;
}

enum OfferKind { discount, package, subscription }

class LaundryOffer {
  final String id;
  final String title;
  final String? description;
  final OfferKind kind;
  final DateTime? validUntil;

  const LaundryOffer({
    required this.id,
    required this.title,
    this.description,
    this.kind = OfferKind.discount,
    this.validUntil,
  });
}

/// تفاصيل المغسلة. كل شيء اختياري ما عدا الملخص:
/// workingHours == null يعني أن المواعيد غير متوفرة (لا نخترعها).
class LaundryDetails {
  final Laundry summary;
  final String? description;
  final String? address;
  final GeoPoint? location;
  final List<ServiceGroup> serviceGroups;
  final List<WorkingDay>? workingHours;
  final List<LaundryOffer> offers;

  /// رسوم التوصيل لهذه المغسلة (من الـ backend، قابلة للتغيير). null = غير محددة.
  final double? deliveryFee;

  const LaundryDetails({
    required this.summary,
    this.description,
    this.address,
    this.location,
    this.serviceGroups = const [],
    this.workingHours,
    this.offers = const [],
    this.deliveryFee,
  });
}

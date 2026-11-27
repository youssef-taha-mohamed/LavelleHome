// المسار: lib/feature/laundry/data/laundry_details_repository.dart
import 'package:flutter/material.dart' show TimeOfDay;
import '../../../address/domain/entities/address.dart' show GeoPoint ;
import '../../data/module/laundry_model.dart';
import 'laundry_repository.dart';
import '../../data/laundry_details.dart';

abstract class LaundryDetailsRepository {
  Future<LaundryDetails> fetchDetails(String id);
}

enum DetailsScenario { normal, error, noConnection }

/// بيانات تجريبية تغطي: كاملة (l1) / بدون عروض (l2) / مغلقة (l3) /
/// غير متاحة (l4) / بيانات ناقصة بلا مواعيد ولا موقع (l5)
class MockLaundryDetailsRepository implements LaundryDetailsRepository {
  final DetailsScenario scenario;

  const MockLaundryDetailsRepository({this.scenario = DetailsScenario.normal});

  @override
  Future<LaundryDetails> fetchDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));

    switch (scenario) {
      case DetailsScenario.error:
        throw Exception('mock server error');
      case DetailsScenario.noConnection:
        throw const NoConnectionException();
      case DetailsScenario.normal:
        break;
    }

    final summary = MockHomeRepository.laundries.firstWhere(
      (l) => l.id == id,
      orElse: () => throw Exception('not found'),
    );
    return _build(summary);
  }

  // ───────── helpers ─────────

  static List<WorkingDay> _week(
    TimeOfDay opens,
    TimeOfDay closes, {
    int? closedWeekday,
    TimeOfDay? fridayOpens,
  }) {
    return [
      for (var d = 1; d <= 7; d++)
        if (d == closedWeekday)
          WorkingDay(weekday: d)
        else
          WorkingDay(
            weekday: d,
            opens: (d == 5 && fridayOpens != null) ? fridayOpens : opens,
            closes: closes,
          ),
    ];
  }

  static const _washing = ServiceGroup(
    id: 'washing',
    name: 'غسيل',
    type: LaundryServiceType.washing,
    items: [
      PriceItem(name: 'قميص', price: 12),
      PriceItem(name: 'بنطلون', price: 14),
      PriceItem(name: 'غسيل بالكيلو', price: 30, unit: PricingUnit.kg),
    ],
  );

  static const _ironing = ServiceGroup(
    id: 'ironing',
    name: 'كي',
    type: LaundryServiceType.ironing,
    items: [
      PriceItem(name: 'قميص', price: 8),
      PriceItem(name: 'بنطلون', price: 8),
      PriceItem(name: 'جلابية', price: 12),
    ],
  );

  static const _washIron = ServiceGroup(
    id: 'wash_iron',
    name: 'غسيل وكي',
    type: LaundryServiceType.washing,
    items: [
      PriceItem(name: 'قميص', price: 18),
      PriceItem(name: 'بنطلون', price: 20),
    ],
  );

  static const _dry = ServiceGroup(
    id: 'dry',
    name: 'تنظيف جاف',
    type: LaundryServiceType.dryCleaning,
    items: [
      PriceItem(name: 'بدلة', price: 90),
      PriceItem(name: 'فستان', price: 80),
      PriceItem(name: 'معطف', price: 100),
    ],
  );

  static const _carpet = ServiceGroup(
    id: 'carpet',
    name: 'تنظيف السجاد',
    type: LaundryServiceType.carpet,
    items: [
      PriceItem(name: 'سجاد عادي', price: 45, unit: PricingUnit.squareMeter),
      PriceItem(name: 'سجاد فاخر', price: 70, unit: PricingUnit.squareMeter),
    ],
  );

  LaundryDetails _build(Laundry s) {
    const nine = TimeOfDay(hour: 9, minute: 0);
    const ten = TimeOfDay(hour: 10, minute: 0);
    const twoPm = TimeOfDay(hour: 14, minute: 0);
    const eight = TimeOfDay(hour: 20, minute: 0);
    const tenPm = TimeOfDay(hour: 22, minute: 0);

    switch (s.id) {
      case 'l1':
        return LaundryDetails(
          summary: s,
          description:
              'مغسلة متكاملة للغسيل والكي والتنظيف الجاف بأحدث الماكينات.',
          address: 'مدينتي، مجموعة 36',
          location: const GeoPoint(30.1085, 31.6385),
          serviceGroups: const [_washing, _ironing, _washIron, _dry],
          workingHours: _week(nine, tenPm, fridayOpens: twoPm),
          offers: [
            LaundryOffer(
              id: 'o1',
              title: 'خصم 20% على أول طلب',
              description: 'للعملاء الجدد على كل الخدمات',
              validUntil: DateTime(2026, 12, 31),
            ),
            const LaundryOffer(
              id: 'o2',
              title: 'باقة العائلة الشهرية',
              description: '30 قطعة غسيل وكي بسعر مخفّض',
              kind: OfferKind.subscription,
            ),
          ],
        );
      case 'l2':
        return LaundryDetails(
          summary: s,
          address: 'مدينتي، مجموعة 12',
          location: const GeoPoint(30.1102, 31.6411),
          serviceGroups: const [_washing, _ironing],
          workingHours: _week(ten, eight),
        );
      case 'l3':
        return LaundryDetails(
          summary: s,
          description: 'متخصصون في تنظيف السجاد والموكيت.',
          address: 'الشروق، المنطقة الأولى',
          location: const GeoPoint(30.1236, 31.6070),
          serviceGroups: const [_carpet, _dry],
          workingHours: _week(nine, eight, closedWeekday: 5),
          offers: [
            LaundryOffer(
              id: 'o3',
              title: 'تنظيف السجاد بخصم 15%',
              kind: OfferKind.package,
              validUntil: DateTime(2026, 12, 15),
            ),
          ],
        );
      case 'l4':
        return LaundryDetails(
          summary: s,
          address: 'الشروق، المجاورة الأولى',
          location: const GeoPoint(30.1201, 31.6123),
          serviceGroups: const [_washing, _ironing, _dry, _carpet],
          workingHours: _week(nine, tenPm),
        );
      default:
        // بيانات ناقصة: بلا مواعيد ولا موقع ولا عنوان ولا عروض
        return LaundryDetails(summary: s, serviceGroups: const [_dry]);
    }
  }
}

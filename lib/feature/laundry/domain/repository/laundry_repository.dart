import '../../../address/domain/entities/address.dart';
import '../../data/module/laundry_model.dart';

enum PromoSource { platform, laundry }

/// بانر ترويجي. المحتوى قابل للضبط من الـ backend (منصة أو مغسلة).
class PromoBanner {
  final String id;
  final String title;
  final String? subtitle;
  final PromoSource source;
  final String? laundryId; // عند الضغط: يفتح تفاصيل المغسلة
  final String? laundryName; // يظهر كشارة على بانرات المغاسل
  final String? imageUrl;

  const PromoBanner({
    required this.id,
    required this.title,
    this.subtitle,
    this.source = PromoSource.platform,
    this.laundryId,
    this.laundryName,
    this.imageUrl,
  });
}

class HomeData {
  final List<PromoBanner> banners;
  final List<Laundry> laundries;

  const HomeData({required this.banners, required this.laundries});
}

class NoConnectionException implements Exception {
  const NoConnectionException();
}

// ───────────────────────── Repository ─────────────────────────

abstract class HomeRepository {
  /// [location] هو الموقع المختار (عنوان محفوظ أو إحداثيات) ليحدد الـ API المغاسل القريبة
  Future<HomeData> fetchHome({SelectedLocation? location});
}

/// سيناريوهات لتجربة كل حالات الشاشة قبل جاهزية الـ API
enum HomeScenario { normal, empty, error, noConnection }

class MockHomeRepository implements HomeRepository {
  final HomeScenario scenario;

  const MockHomeRepository({this.scenario = HomeScenario.normal});

  @override
  Future<HomeData> fetchHome({SelectedLocation? location}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    switch (scenario) {
      case HomeScenario.error:
        throw Exception('mock server error');
      case HomeScenario.noConnection:
        throw const NoConnectionException();
      case HomeScenario.empty:
        return const HomeData(banners: _banners, laundries: []);
      case HomeScenario.normal:
        // بدون موقع لا مغاسل (الواجهة تطلب اختيار موقع قبل ذلك أصلاً)
        if (location == null) {
          return const HomeData(banners: _banners, laundries: []);
        }
        return const HomeData(banners: _banners, laundries: laundries);
    }
  }

  static const _banners = [
    PromoBanner(
      id: 'b1',
      title: 'خصم 20% على أول طلب',
      subtitle: 'جرّب لافيل واستلم غسيلك لحد باب بيتك',
    ),
    PromoBanner(
      id: 'b2',
      title: 'كي مجاني مع كل غسيل',
      subtitle: 'عرض لفترة محدودة',
      source: PromoSource.laundry,
      laundryId: 'l1',
      laundryName: 'لافيل مدينتي',
    ),
    PromoBanner(
      id: 'b3',
      title: 'تنظيف السجاد بخصم 15%',
      source: PromoSource.laundry,
      laundryId: 'l3',
      laundryName: 'الأميرة للسجاد',
    ),
  ];

  // يغطي الحالات: كل البيانات / بدون تقييم / بدون سعر / مغلق / غير متاح
  static const laundries = [
    Laundry(
      id: 'l1',
      name: 'لافيل مدينتي',
      area: 'مدينتي',
      distanceKm: 0.8,
      rating: 4.8,
      ratingCount: 212,
      services: [
        LaundryServiceType.washing,
        LaundryServiceType.ironing,
        LaundryServiceType.dryCleaning,
      ],
      startingPrice: 15,
      status: LaundryStatus.open,
      location: GeoPoint(30.1085, 31.6385),
    ),
    Laundry(
      id: 'l2',
      name: 'مغسلة النور',
      area: 'مدينتي',
      distanceKm: 1.6,
      rating: 4.6,
      ratingCount: 98,
      services: [LaundryServiceType.washing, LaundryServiceType.ironing],
      startingPrice: 12,
      status: LaundryStatus.open,
      location: GeoPoint(30.1102, 31.6411),
    ),
    Laundry(
      id: 'l3',
      name: 'الأميرة للسجاد',
      area: 'الشروق',
      distanceKm: 2.4,
      rating: 4.4,
      ratingCount: 54,
      services: [LaundryServiceType.carpet, LaundryServiceType.dryCleaning],
      startingPrice: 60,
      status: LaundryStatus.closed,
      location: GeoPoint(30.1236, 31.6070),
    ),
    Laundry(
      id: 'l4',
      name: 'بريق الشروق',
      area: 'الشروق',
      distanceKm: 3.9,
      rating: 4.7,
      ratingCount: 131,
      services: [
        LaundryServiceType.washing,
        LaundryServiceType.ironing,
        LaundryServiceType.dryCleaning,
        LaundryServiceType.carpet,
      ],
      startingPrice: 18,
      status: LaundryStatus.unavailable,
      location: GeoPoint(30.1201, 31.6123),
    ),
    Laundry(
      id: 'l5',
      name: 'سبارك دراي كلين',
      area: 'مدينتي',
      distanceKm: 5.2,
      services: [LaundryServiceType.dryCleaning, LaundryServiceType.ironing],
    ),
  ];
}

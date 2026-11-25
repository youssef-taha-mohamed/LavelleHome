part of 'home_cubit.dart';

class HomeState {
  final LavelleViewStatus status; // loading | success | error | noConnection
  final List<PromoBanner> banners;
  final List<Laundry> laundries;
  final String? locationLabel;
  final LaundryServiceType? selectedService;
  final String? errorMessage;

  const HomeState({
    this.status = LavelleViewStatus.loading,
    this.banners = const [],
    this.laundries = const [],
    this.locationLabel,
    this.selectedService,
    this.errorMessage,
  });

  /// لم يُحدَّد موقع بعد، فلا نعرض المغاسل بل نطلب تحديد الموقع
  bool get needsLocation =>
      status == LavelleViewStatus.success && locationLabel == null;

  /// القائمة بعد تطبيق فلتر الخدمة (إن وُجد)
  List<Laundry> get visibleLaundries {
    final s = selectedService;
    if (s == null) return laundries;
    return laundries.where((l) => l.services.contains(s)).toList();
  }

  HomeState copyWith({
    LavelleViewStatus? status,
    List<PromoBanner>? banners,
    List<Laundry>? laundries,
    String? locationLabel,
    bool clearLocation = false,
    LaundryServiceType? selectedService,
    bool clearSelectedService = false,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      laundries: laundries ?? this.laundries,
      locationLabel: clearLocation
          ? null
          : (locationLabel ?? this.locationLabel),
      selectedService: clearSelectedService
          ? null
          : (selectedService ?? this.selectedService),
      errorMessage: errorMessage,
    );
  }
}

part of 'laundry_details_cubit.dart';

class LaundryDetailsState {
  final LavelleViewStatus status; // loading | success | error | noConnection
  final LaundryDetails? details;

  /// ملخص جاهز من الكارت لعرض الهيدر فوراً أثناء التحميل
  final Laundry? preview;

  const LaundryDetailsState({
    this.status = LavelleViewStatus.loading,
    this.details,
    this.preview,
  });

  Laundry? get summary => details?.summary ?? preview;
}

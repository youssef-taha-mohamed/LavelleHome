part of 'location_cubit.dart';

class LocationState {
  final bool isLoading; // التحميل الأول للعناوين
  final bool isLocating; // جاري تحديد الموقع الحالي
  final bool locateFailed; // الإذن ممنوح لكن تعذّر الحصول على الموقع
  final List<SavedAddress> addresses;
  final SelectedLocation? selected;
  final LocationPermissionStatus permission;

  const LocationState({
    this.isLoading = true,
    this.isLocating = false,
    this.locateFailed = false,
    this.addresses = const [],
    this.selected,
    this.permission = LocationPermissionStatus.unknown,
  });

  LocationState copyWith({
    bool? isLoading,
    bool? isLocating,
    bool? locateFailed,
    List<SavedAddress>? addresses,
    SelectedLocation? selected,
    LocationPermissionStatus? permission,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      isLocating: isLocating ?? this.isLocating,
      locateFailed: locateFailed ?? this.locateFailed,
      addresses: addresses ?? this.addresses,
      selected: selected ?? this.selected,
      permission: permission ?? this.permission,
    );
  }
}

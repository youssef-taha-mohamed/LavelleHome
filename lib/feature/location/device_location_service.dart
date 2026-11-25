

import '../address/domain/entities/address.dart';

/// واجهة للوصول لموقع الجهاز. التنفيذ الحقيقي في geolocator_device_location_service.dart
abstract class DeviceLocationService {
  Future<LocationPermissionStatus> checkPermission();
  Future<LocationPermissionStatus> requestPermission();
  Future<GeoPoint?> currentPosition();

  /// يفتح إعدادات التطبيق (إذن مرفوض نهائياً) أو إعدادات الموقع (الخدمة متوقفة)
  Future<void> openSettings(LocationPermissionStatus status);
}

/// للتجربة: غيّر [permission] لاختبار كل الحالات
class MockDeviceLocationService implements DeviceLocationService {
  LocationPermissionStatus permission;
  final GeoPoint? position;

  MockDeviceLocationService({
    this.permission = LocationPermissionStatus.granted,
    this.position = const GeoPoint(30.1085, 31.6385),
  });

  @override
  Future<LocationPermissionStatus> checkPermission() async => permission;

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return permission;
  }

  @override
  Future<GeoPoint?> currentPosition() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return position;
  }

  @override
  Future<void> openSettings(LocationPermissionStatus status) async {}
}

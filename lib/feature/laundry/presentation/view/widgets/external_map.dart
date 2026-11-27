// المسار: lib/feature/laundry/presentation/external_map.dart
// يحتاج: flutter pub add url_launcher
// Android 11+: أضف queries لـ https في AndroidManifest. iOS: LSApplicationQueriesSchemes (اختياري).
import 'package:url_launcher/url_launcher.dart';

import '../../../../address/domain/entities/address.dart' show GeoPoint;

/// يفتح تطبيق الخرائط الخارجي بمسار الاتجاهات للوجهة. يرجع false لو فشل.
Future<bool> openExternalDirections(GeoPoint destination) {
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=${destination.lat},${destination.lng}',
  );
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

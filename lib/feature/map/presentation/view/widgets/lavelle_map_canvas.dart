import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../address/domain/entities/address.dart';
import '../../../../laundry/data/module/laundry_model.dart';
import '../../../domain/map_bounds.dart';

/// واجهة تحكم بسيطة تخفي نوع الخريطة عن الشاشة
class LavelleMapController {
  final MapController _inner = MapController();

  void moveTo(GeoPoint point, {double? zoom}) {
    try {
      _inner.move(LatLng(point.lat, point.lng), zoom ?? _inner.camera.zoom);
    } catch (_) {
      // الخريطة لم تُبنَ بعد
    }
  }

  MapBounds? get visibleBounds {
    try {
      final b = _inner.camera.visibleBounds;
      return MapBounds(
        south: b.south,
        west: b.west,
        north: b.north,
        east: b.east,
      );
    } catch (_) {
      return null;
    }
  }

  void dispose() => _inner.dispose();
}

class LavelleMapCanvas extends StatelessWidget {
  final LavelleMapController controller;
  final GeoPoint center;
  final double zoom;
  final List<Laundry> laundries;
  final String? selectedId;
  final ValueChanged<Laundry> onMarkerTap;
  final VoidCallback onMapTap;
  final VoidCallback onUserMoved;
  final VoidCallback onTileError;

  /// غيّر القيمة لإعادة تحميل التايلز بعد فشل
  final int reloadKey;

  const LavelleMapCanvas({
    super.key,
    required this.controller,
    required this.center,
    required this.laundries,
    required this.selectedId,
    required this.onMarkerTap,
    required this.onMapTap,
    required this.onUserMoved,
    required this.onTileError,
    this.zoom = 14,
    this.reloadKey = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // المختارة آخراً لتُرسم فوق الباقي
    final items = laundries.where((l) => l.location != null).toList()
      ..sort(
        (a, b) =>
            (a.id == selectedId ? 1 : 0).compareTo(b.id == selectedId ? 1 : 0),
      );

    return FlutterMap(
      mapController: controller._inner,
      options: MapOptions(
        initialCenter: LatLng(center.lat, center.lng),
        initialZoom: zoom,
        minZoom: 5,
        maxZoom: 18,
        onTap: (_, _) => onMapTap(),
        onPositionChanged: (camera, hasGesture) {
          if (hasGesture) onUserMoved();
        },
      ),
      children: [
        TileLayer(
          key: ValueKey<int>(reloadKey),
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'lavelle_pro',
          tileBuilder: isDark ? darkModeTileBuilder : null,
          errorTileCallback: (tile, error, stackTrace) => onTileError(),
        ),
        // للتوسّع لعدد كبير من المغاسل: لفّ MarkerLayer بـ flutter_map_marker_cluster هنا فقط
        MarkerLayer(
          markers: [
            for (final l in items)
              Marker(
                point: LatLng(l.location!.lat, l.location!.lng),
                width: 56,
                height: 64,
                // topCenter: طرف الدبوس السفلي يقع على الإحداثية
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onMarkerTap(l),
                  child: _LaundryPin(
                    selected: l.id == selectedId,
                    status: l.status,
                  ),
                ),
              ),
          ],
        ),
        // إسناد OpenStreetMap مطلوب بموجب الترخيص
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          showFlutterMapAttribution: false,
          attributions: [TextSourceAttribution('© OpenStreetMap contributors')],
        ),
      ],
    );
  }
}

/// دبوس المغسلة: دائرة بتدرج الهوية (رمادي لو مغلقة/غير متاحة) وذيل صغير.
/// المختار أكبر وبحدّ ذهبي.
class _LaundryPin extends StatelessWidget {
  final bool selected;
  final LaundryStatus status;

  const _LaundryPin({required this.selected, required this.status});

  @override
  Widget build(BuildContext context) {
    final inactive =
        status == LaundryStatus.closed || status == LaundryStatus.unavailable;
    final size = selected ? 46.0 : 38.0;
    final tailColor = inactive ? MyColors.grey500 : MyColors.primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: inactive
                ? const LinearGradient(
                    colors: [MyColors.grey500, MyColors.grey600],
                  )
                : LavelleGradients.primary,
            border: Border.all(
              color: selected ? MyColors.goldAccent : Colors.white,
              width: selected ? 3 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.local_laundry_service_rounded,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
        CustomPaint(size: const Size(12, 8), painter: _TailPainter(tailColor)),
      ],
    );
  }
}

class _TailPainter extends CustomPainter {
  final Color color;

  _TailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TailPainter old) => old.color != color;
}

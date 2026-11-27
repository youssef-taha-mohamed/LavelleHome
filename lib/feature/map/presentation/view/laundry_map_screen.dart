import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/main_text.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../address/domain/entities/address.dart';
import '../../../laundry/data/module/laundry_model.dart';
import '../../../laundry/presentation/view/laundry_details_screen.dart';
import '../../../laundry/presentation/view/widgets/lundry_card.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../location/presentation/widgets/location_sheet.dart';
import '../../domain/map_bounds.dart';
import '../../domain/repository/map_repository.dart';
import '../cubits/map_cubit.dart';
import 'widgets/lavelle_map_canvas.dart';

/// يفتح الخريطة الكاملة.
/// [center] لتحديد مركز مختلف عن الموقع المختار، و[selectLaundryId] لتحديد مغسلة فور الفتح.
Future<void> openLaundryMap(
  BuildContext context, {
  GeoPoint? center,
  String? selectLaundryId,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          LaundryMapScreen(center: center, selectLaundryId: selectLaundryId),
    ),
  );
}

class LaundryMapScreen extends StatelessWidget {
  final GeoPoint? center;
  final String? selectLaundryId;

  const LaundryMapScreen({super.key, this.center, this.selectLaundryId});

  @override
  Widget build(BuildContext context) {
    final start =
        center ?? centerFor(context.read<LocationCubit>().state.selected);

    return BlocProvider(
      create: (_) =>
          MapCubit(const MockMapRepository())
            ..loadInitial(MapBounds.around(start), selectId: selectLaundryId),
      child: _MapView(center: start),
    );
  }
}

class _MapView extends StatefulWidget {
  final GeoPoint center;

  const _MapView({required this.center});

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  final LavelleMapController _map = LavelleMapController();
  int _tileErrors = 0;
  int _reloadKey = 0;

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  void _onTileError() {
    // نعرض البانر بعد عدة أخطاء متتالية فقط (تايل واحد فاشل لا يهم)
    if (_tileErrors >= 3) return;
    _tileErrors++;
    if (_tileErrors == 3 && mounted) setState(() {});
  }

  void _reloadTiles() {
    setState(() {
      _tileErrors = 0;
      _reloadKey++;
    });
  }

  Future<void> _goToMyLocation() async {
    final locationCubit = context.read<LocationCubit>();
    final ok = await locationCubit.useCurrentLocation();
    if (!mounted) return;

    final point = locationCubit.state.selected?.point;
    if (ok && point != null) {
      _map.moveTo(point, zoom: 15);
    } else {
      // رفض إذن أو تعذّر الموقع: النافذة تشرح السبب وتعرض بدائل يدوية
      showLocationSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapCubit>();
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BlocConsumer<MapCubit, MapState>(
      // عند اختيار مغسلة: حرّك الخريطة إليها
      listenWhen: (a, b) =>
          a.selectedId != b.selectedId && b.selectedId != null,
      listener: (context, state) {
        final loc = state.selected?.location;
        if (loc != null) _map.moveTo(loc);
      },
      builder: (context, state) {
        final selected = state.selected;
        final loadFailed =
            state.status == LavelleViewStatus.error ||
            state.status == LavelleViewStatus.noConnection;
        final noneHere =
            state.status == LavelleViewStatus.success &&
            state.laundries.isEmpty;

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: LavelleMapCanvas(
                  controller: _map,
                  center: widget.center,
                  laundries: state.laundries,
                  selectedId: state.selectedId,
                  reloadKey: _reloadKey,
                  onMarkerTap: (l) => cubit.select(l.id),
                  onMapTap: () => cubit.select(null),
                  onUserMoved: cubit.onCameraMoved,
                  onTileError: _onTileError,
                ),
              ),

              // ───── الشريط العلوي ─────
              Positioned(
                top: topInset + 8,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _MapIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: state.isLoading
                                  ? _StatusPill(
                                      key: const ValueKey('loading'),
                                      loading: true,
                                      text: context.l10n.map_loading_laundries,
                                    )
                                  : state.searchHereVisible
                                  ? _StatusPill(
                                      key: const ValueKey('search'),
                                      icon: Icons.refresh_rounded,
                                      text: context.l10n.map_search_this_area,
                                      onTap: () {
                                        final b = _map.visibleBounds;
                                        if (b != null) cubit.searchArea(b);
                                      },
                                    )
                                  : const SizedBox(key: ValueKey('none')),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // لتوسيط الكبسولة
                      ],
                    ),
                    if (_tileErrors >= 3) ...[
                      const SizedBox(height: 10),
                      _TileErrorBanner(onRetry: _reloadTiles),
                    ],
                  ],
                ),
              ),

              // فشل تحميل البيانات
              if (loadFailed)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LavelleCard(
                      child: LavelleErrorView(
                        onRetry: cubit.retry,
                        isNoConnection:
                            state.status == LavelleViewStatus.noConnection,
                      ),
                    ),
                  ),
                ),

              // ───── الأسفل: موقعي + (معاينة | لا مغاسل | زر القائمة) ─────
              Positioned(
                left: 16,
                right: 16,
                bottom: bottomInset + 28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: BlocBuilder<LocationCubit, LocationState>(
                        buildWhen: (a, b) => a.isLocating != b.isLocating,
                        builder: (context, loc) => _MapIconButton(
                          icon: Icons.my_location_rounded,
                          tooltip: context.l10n.my_location,
                          loading: loc.isLocating,
                          onTap: _goToMyLocation,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: selected != null
                          ? _PreviewCard(
                              key: ValueKey(selected.id),
                              laundry: selected,
                              onView: () => openLaundryDetails(
                                context,
                                id: selected.id,
                                preview: selected,
                              ),
                            )
                          : noneHere
                          ? const _EmptyAreaCard(key: ValueKey('empty'))
                          : Center(
                              key: const ValueKey('list'),
                              child: LavelleButton(
                                title: context.l10n.map_show_list,
                                icon: Icons.view_list_rounded,
                                variant: LavelleButtonVariant.secondary,
                                expand: false,
                                height: 46,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════
// عناصر الواجهة فوق الخريطة
// ═════════════════════════════════════════════════════════════

class _MapIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool loading;

  const _MapIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: t.card,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: loading ? null : onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: t.accent,
                      ),
                    )
                  : Icon(icon, color: t.accent, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// كبسولة أعلى الخريطة: "جاري التحميل" أو "ابحث في هذه المنطقة"
class _StatusPill extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onTap;

  const _StatusPill({
    super.key,
    required this.text,
    this.icon,
    this.loading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Material(
      color: t.card,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (loading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: t.accent,
                  ),
                )
              else if (icon != null)
                Icon(icon, size: 18, color: t.accent),
              MainText(
                text,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: t.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileErrorBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const _TileErrorBanner({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.warning600.withValues(alpha: 0.5)),
      ),
      child: Row(
        spacing: 10,
        children: [
          const Icon(Icons.map_outlined, color: MyColors.warning600, size: 20),
          Expanded(
            child: MainText(
              context.l10n.map_load_failed,
              fontSize: 13,
              color: t.text,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: MainText(
              context.l10n.retry,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: t.accent,
            ),
          ),
        ],
      ),
    );
  }
}

/// كارت المعاينة: مدمج حتى لا يغطي الخريطة
class _PreviewCard extends StatelessWidget {
  final Laundry laundry;
  final VoidCallback onView;

  const _PreviewCard({super.key, required this.laundry, required this.onView});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    final l = laundry;
    final chip = laundryStatusChip(context, l.status);
    final services = l.services
        .map((s) => laundryServiceLabel(context, s))
        .join(' • ');

    return LavelleCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              LaundryLogo(name: l.name, url: l.logoUrl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    MainText(
                      l.name,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: t.text,
                    ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (l.rating != null)
                          LavelleRatingBadge(
                            rating: l.rating!,
                            count: l.ratingCount,
                          ),
                        if (l.distanceKm != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.near_me_rounded,
                                size: 14,
                                color: t.subText,
                              ),
                              MainText(
                                '${l.distanceKm!.toStringAsFixed(1)} ${l10n.unit_km}',
                                fontSize: 12.5,
                                color: t.subText,
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (services.isNotEmpty)
                      MainText(services, fontSize: 12, color: t.subText),
                    ?chip,
                  ],
                ),
              ),
            ],
          ),
          LavelleButton(
            title: l10n.view_laundry,
            icon: Icons.arrow_forward_rounded,
            height: 46,
            onTap: onView,
          ),
        ],
      ),
    );
  }
}

class _EmptyAreaCard extends StatelessWidget {
  const _EmptyAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return LavelleCard(
      child: Row(
        spacing: 12,
        children: [
          const LavelleIconBadge(icon: Icons.storefront_outlined, size: 44),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                MainText(
                  l10n.map_no_laundries_here,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
                MainText(
                  l10n.map_no_laundries_hint,
                  fontSize: 12.5,
                  color: t.subText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

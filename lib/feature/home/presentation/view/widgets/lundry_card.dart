import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../data/home_model.dart';

String laundryServiceLabel(BuildContext context, LaundryServiceType type) {
  final l10n = context.l10n;
  switch (type) {
    case LaundryServiceType.washing:
      return l10n.service_washing;
    case LaundryServiceType.ironing:
      return l10n.service_ironing;
    case LaundryServiceType.dryCleaning:
      return l10n.service_dry_cleaning;
    case LaundryServiceType.carpet:
      return l10n.service_carpet;
  }
}

class LaundryCard extends StatelessWidget {
  final Laundry laundry;
  final VoidCallback? onTap;

  const LaundryCard({super.key, required this.laundry, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    final l = laundry;
    final statusChip = _statusChip(context);
    final shownServices = l.services.take(3).toList();
    final extra = l.services.length - shownServices.length;

    return LavelleCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LaundryLogo(name: l.name, url: l.logoUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم + التقييم
                Row(
                  children: [
                    Expanded(
                      child: MainText(
                        l.name,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                      ),
                    ),
                    if (l.rating != null) ...[
                      const SizedBox(width: 8),
                      LavelleRatingBadge(
                        rating: l.rating!,
                        count: l.ratingCount,
                      ),
                    ],
                  ],
                ),

                // المسافة + حالة الفتح
                if (l.distanceKm != null || statusChip != null) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
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
                      ?statusChip,
                    ],
                  ),
                ],

                // الخدمات (حد أقصى 3)
                if (shownServices.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final s in shownServices)
                        _ServiceMiniChip(
                          icon: s.icon,
                          label: laundryServiceLabel(context, s),
                          color: t.accent,
                        ),
                      if (extra > 0)
                        _ServiceMiniChip(label: '+$extra', color: t.subText),
                    ],
                  ),
                ],

                // مؤشر السعر + سهم
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (l.startingPrice != null)
                      MainText(
                        '${l10n.starting_from} ${_fmt(l.startingPrice!)} ${l10n.currency_egp}',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: t.accent,
                      ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: t.subText.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);

  /// unknown ← لا نعرض شيئاً (لا نخترع مواعيد)
  Widget? _statusChip(BuildContext context) {
    final l10n = context.l10n;
    switch (laundry.status) {
      case LaundryStatus.open:
        return LavelleChip(
          label: l10n.status_open,
          tone: LavelleTone.success,
          icon: Icons.circle,
        );
      case LaundryStatus.closed:
        return LavelleChip(label: l10n.status_closed, tone: LavelleTone.danger);
      case LaundryStatus.unavailable:
        return LavelleChip(
          label: l10n.status_unavailable,
          tone: LavelleTone.warning,
          icon: Icons.pause_circle_outline_rounded,
        );
      case LaundryStatus.unknown:
        return null;
    }
  }
}

class _ServiceMiniChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;

  const _ServiceMiniChip({this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (icon != null) Icon(icon, size: 12, color: color),
          MainText(
            label,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _LaundryLogo extends StatelessWidget {
  final String name;
  final String? url;

  const _LaundryLogo({required this.name, this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 78,
        height: 78,
        child: url == null
            ? _fallback()
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(),
              ),
      ),
    );
  }

  Widget _fallback() {
    final initial = name.trim().isEmpty ? '?' : name.trim().substring(0, 1);
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: LavelleGradients.primary),
      child: Center(
        child: MainText(
          initial.toUpperCase(),
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

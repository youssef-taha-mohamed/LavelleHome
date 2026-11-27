import 'package:intl/intl.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../data/module/laundry_model.dart';
import '../../../data/laundry_details.dart';
import 'lundry_card.dart';

String _fmtPrice(double v) =>
    v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);

String pricingUnitLabel(BuildContext context, PricingUnit unit) {
  final l10n = context.l10n;
  switch (unit) {
    case PricingUnit.piece:
      return l10n.unit_piece;
    case PricingUnit.kg:
      return l10n.unit_kg;
    case PricingUnit.squareMeter:
      return l10n.unit_sqm;
  }
}

// ═════════════════════════════════════════════════════════════
// أدوات مشتركة
// ═════════════════════════════════════════════════════════════

class DetailsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailsSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        LavelleSectionHeader(title: title),
        child,
      ],
    );
  }
}

/// بطاقة نص هادئة لحالة "لا توجد بيانات"
class _MutedCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MutedCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    return LavelleCard(
      child: Row(
        spacing: 12,
        children: [
          Icon(icon, color: t.subText),
          Expanded(child: MainText(text, fontSize: 13.5, color: t.subText)),
        ],
      ),
    );
  }
}

/// شريط تنبيه (مغلقة / غير متاحة)
class NoticeBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const NoticeBanner({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        spacing: 10,
        children: [
          Icon(icon, color: color, size: 22),
          Expanded(child: MainText(text, fontSize: 13, color: t.text)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// الخدمات والأسعار
// ═════════════════════════════════════════════════════════════

class ServicesSection extends StatelessWidget {
  final List<ServiceGroup> groups;

  const ServicesSection({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return _MutedCard(
        icon: Icons.local_laundry_service_outlined,
        text: context.l10n.services_not_listed,
      );
    }

    return Column(
      spacing: 10,
      children: [
        for (var i = 0; i < groups.length; i++)
          _ServiceGroupCard(group: groups[i], initiallyExpanded: i == 0),
      ],
    );
  }
}

class _ServiceGroupCard extends StatelessWidget {
  final ServiceGroup group;
  final bool initiallyExpanded;

  const _ServiceGroupCard({
    required this.group,
    required this.initiallyExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return LavelleCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          iconColor: t.accent,
          collapsedIconColor: t.subText,
          leading: LavelleIconBadge(
            icon: group.type?.icon ?? Icons.local_laundry_service_rounded,
            size: 40,
            filled: false,
          ),
          title: MainText(
            group.name,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: t.text,
          ),
          children: [
            for (var i = 0; i < group.items.length; i++) ...[
              if (i > 0)
                Divider(height: 1, color: t.border.withValues(alpha: 0.6)),
              _PriceRow(item: group.items[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final PriceItem item;

  const _PriceRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: MainText(
              item.name,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: t.text,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 2,
            children: [
              MainText(
                '${_fmtPrice(item.price)} ${l10n.currency_egp}',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: t.accent,
              ),
              MainText(
                pricingUnitLabel(context, item.unit),
                fontSize: 11,
                color: t.subText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// مواعيد العمل
// ═════════════════════════════════════════════════════════════

class HoursSection extends StatefulWidget {
  final List<WorkingDay>? hours; // null = غير متوفرة
  final LaundryStatus status;

  const HoursSection({super.key, required this.hours, required this.status});

  @override
  State<HoursSection> createState() => _HoursSectionState();
}

class _HoursSectionState extends State<HoursSection> {
  bool _expanded = false;

  // ترتيب الأسبوع المصري: السبت أولاً
  static const _order = [6, 7, 1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);
    final hours = widget.hours;

    if (hours == null || hours.isEmpty) {
      return _MutedCard(
        icon: Icons.schedule_rounded,
        text: l10n.hours_unavailable,
      );
    }

    final today = DateTime.now().weekday;
    final locale = Localizations.localeOf(context).toString();
    String dayName(int d) =>
        DateFormat.EEEE(locale).format(DateTime(2024, 1, d));
    String time(TimeOfDay x) =>
        MaterialLocalizations.of(context).formatTimeOfDay(x);
    String range(WorkingDay d) =>
        d.isClosed ? l10n.closed_day : '${time(d.opens!)} – ${time(d.closes!)}';

    WorkingDay? dayOf(int d) {
      for (final x in hours) {
        if (x.weekday == d) return x;
      }
      return null;
    }

    final todayEntry = dayOf(today);
    final statusChip = laundryStatusChip(context, widget.status);

    return LavelleCard(
      padding: EdgeInsets.zero,
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              spacing: 12,
              children: [
                const LavelleIconBadge(
                  icon: Icons.schedule_rounded,
                  size: 40,
                  filled: false,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      MainText(l10n.today, fontSize: 12, color: t.subText),
                      MainText(
                        todayEntry == null ? '—' : range(todayEntry),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                      ),
                    ],
                  ),
                ),
                ?statusChip,
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: t.subText,
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Column(
                      children: [
                        Divider(height: 1, color: t.border),
                        for (final d in _order)
                          if (dayOf(d) != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MainText(
                                      dayName(d),
                                      fontSize: 13.5,
                                      fontWeight: d == today
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: d == today ? t.accent : t.text,
                                    ),
                                  ),
                                  MainText(
                                    range(dayOf(d)!),
                                    fontSize: 13.5,
                                    fontWeight: d == today
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    color: dayOf(d)!.isClosed
                                        ? MyColors.error
                                        : (d == today ? t.accent : t.subText),
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// الموقع
// ═════════════════════════════════════════════════════════════

class LocationSection extends StatelessWidget {
  final String? address;
  final bool hasCoordinates;
  final VoidCallback onOpenMap;
  final VoidCallback onDirections;

  const LocationSection({
    super.key,
    required this.address,
    required this.hasCoordinates,
    required this.onOpenMap,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);

    if (address == null && !hasCoordinates) {
      return _MutedCard(
        icon: Icons.location_off_outlined,
        text: l10n.location_info_unavailable,
      );
    }

    return LavelleCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          if (address != null)
            Row(
              spacing: 8,
              children: [
                Icon(Icons.location_on_rounded, color: t.accent, size: 20),
                Expanded(
                  child: MainText(
                    address!,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
              ],
            ),
          if (hasCoordinates) _MapPreview(onTap: onOpenMap),
          Row(
            spacing: 8,
            children: [
              Icon(Icons.directions_walk_rounded, size: 18, color: t.subText),
              Expanded(
                child: MainText(
                  l10n.visit_or_order_hint,
                  fontSize: 12.5,
                  color: t.subText,
                ),
              ),
            ],
          ),
          if (hasCoordinates)
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: LavelleButton(
                    title: l10n.show_on_map,
                    icon: Icons.map_outlined,
                    variant: LavelleButtonVariant.secondary,
                    height: 48,
                    onTap: onOpenMap,
                  ),
                ),
                Expanded(
                  child: LavelleButton(
                    title: l10n.get_directions,
                    icon: Icons.near_me_rounded,
                    height: 48,
                    onTap: onDirections,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// معاينة خريطة تصميمية (خطوط شوارع + دبوس). تُستبدل بخريطة حقيقية في خطوة 5.
class _MapPreview extends StatelessWidget {
  final VoidCallback onTap;

  const _MapPreview({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _MapPainter(isDark: t.isDark)),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LavelleGradients.primary,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_laundry_service_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final bool isDark;

  _MapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = isDark
          ? MyColors.skyBlue.withValues(alpha: 0.08)
          : MyColors.skyBlue.withValues(alpha: 0.14);
    canvas.drawRect(Offset.zero & size, bg);

    final minor = Paint()
      ..color = (isDark ? Colors.white : MyColors.primaryColor).withValues(
        alpha: 0.07,
      )
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minor);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }

    final road = Paint()
      ..color = (isDark ? Colors.white : Colors.white).withValues(
        alpha: isDark ? 0.14 : 0.9,
      )
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(0, size.height * 0.62),
      Offset(size.width, size.height * 0.34),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.46, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.78, 0),
      Offset(size.width * 0.66, size.height),
      road,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.isDark != isDark;
}

// ═════════════════════════════════════════════════════════════
// العروض
// ═════════════════════════════════════════════════════════════

class OffersSection extends StatelessWidget {
  final List<LaundryOffer> offers;
  final ValueChanged<LaundryOffer> onOfferTap;

  const OffersSection({
    super.key,
    required this.offers,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        for (final o in offers)
          _OfferCard(offer: o, onTap: () => onOfferTap(o)),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final LaundryOffer offer;
  final VoidCallback onTap;

  const _OfferCard({required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    final IconData icon;
    final String kind;
    switch (offer.kind) {
      case OfferKind.discount:
        icon = Icons.percent_rounded;
        kind = l10n.offer_kind_discount;
        break;
      case OfferKind.package:
        icon = Icons.inventory_2_outlined;
        kind = l10n.offer_kind_package;
        break;
      case OfferKind.subscription:
        icon = Icons.workspace_premium_outlined;
        kind = l10n.offer_kind_subscription;
        break;
    }

    final locale = Localizations.localeOf(context).toString();
    final validity = offer.validUntil == null
        ? null
        : '${l10n.valid_until} ${DateFormat.yMMMd(locale).format(offer.validUntil!)}';

    return LavelleCard(
      onTap: offer.kind == OfferKind.subscription ? onTap : null,
      padding: const EdgeInsets.all(14),
      borderColor: MyColors.goldAccent.withValues(alpha: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          LavelleIconBadge(
            icon: icon,
            size: 42,
            filled: false,
            color: t.isDark ? MyColors.goldAccent : MyColors.warning700,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: MainText(
                        offer.title,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                      ),
                    ),
                    LavelleChip(label: kind, tone: LavelleTone.warning),
                  ],
                ),
                if (offer.description != null)
                  MainText(
                    offer.description!,
                    fontSize: 12.5,
                    color: t.subText,
                  ),
                if (validity != null)
                  MainText(
                    validity,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
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

import '../../../../shared/widgets/shared_widgets.dart';
import '../../../laundry/data/laundry_details.dart';
import '../../../laundry/presentation/view/widgets/laundry_details_section.dart';
import '../../domain/order_config.dart';
import '../../domain/order_line.dart';
import '../../domain/order_pricing.dart';
import '../cubit/order_draft_cubit.dart';
import '../order_formatters.dart';

Future<void> openOrderSummary(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const OrderSummaryScreen()),
  );
}

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final l10n = context.l10n;

    return BlocBuilder<OrderDraftCubit, OrderDraftState>(
      builder: (context, draft) {
        return Scaffold(
          bottomNavigationBar: draft.isEmpty
              ? null
              : _ContinueBar(pricing: draft.pricing),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LavelleHeroBackground(
                    height: topInset + 175,
                    showBubbles: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: const _BackButton(),
                      ),
                      const SizedBox(height: 14),
                      MainText(
                        l10n.order_summary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      MainText(
                        '${l10n.ordering_from} ${draft.laundryName ?? ''}',
                        fontSize: 13.5,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 30),
                      if (draft.isEmpty)
                        LavelleStateView(
                          icon: Icons.shopping_bag_outlined,
                          title: l10n.order_empty_title,
                          message: l10n.order_empty_message,
                          actionLabel: l10n.go_back,
                          onAction: () => Navigator.of(context).pop(),
                        )
                      else
                        _SummaryContent(draft: draft),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  final OrderDraftState draft;

  const _SummaryContent({required this.draft});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);

    // نجمّع الأسطر حسب الخدمة مع الحفاظ على ترتيب الاختيار
    final byGroup = <String, List<OrderLine>>{};
    for (final line in draft.items) {
      byGroup.putIfAbsent(line.groupId, () => []).add(line);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        if (draft.kinds.isNotEmpty) _KindCard(kinds: draft.kinds),
        LavelleSectionHeader(
          title: l10n.selected_services,
          actionLabel: l10n.edit_order,
          onAction: () => Navigator.of(context).pop(),
        ),
        for (final lines in byGroup.values)
          _GroupLines(groupName: lines.first.groupName, lines: lines),
        _TotalsCard(pricing: draft.pricing),
        if (kPriceIsEstimate)
          NoticeBanner(
            icon: Icons.info_outline_rounded,
            text: l10n.price_estimate_note,
            color: t.accent,
          ),
      ],
    );
  }
}

/// نوع الطلب (ملابس/سجاد) لأنه يحدد وسيلة الاستلام المناسبة
/// نوع الطلب (ملابس و/أو سجاد) لأنه يحدد وسيلة الاستلام المناسبة
class _KindCard extends StatelessWidget {
  final List<OrderKind> kinds;

  const _KindCard({required this.kinds});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return LavelleCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const LavelleIconBadge(icon: Icons.local_shipping_outlined, size: 44),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                MainText(
                  l10n.order_kind_title,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (final k in kinds)
                      LavelleChip(
                        label: orderKindLabel(context, k),
                        icon: orderKindIcon(k),
                      ),
                  ],
                ),
                MainText(
                  l10n.order_pickup_hint,
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

class _GroupLines extends StatelessWidget {
  final String groupName;
  final List<OrderLine> lines;

  const _GroupLines({required this.groupName, required this.lines});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return LavelleCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            groupName,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            color: t.accent,
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: t.border.withValues(alpha: 0.6)),
            _LineRow(line: lines[i]),
          ],
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  final OrderLine line;

  const _LineRow({required this.line});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    MainText(
                      line.itemName,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: t.text,
                    ),
                    if (line.finish != null)
                      LavelleChip(
                        label: garmentFinishLabel(context, line.finish!),
                        icon: garmentFinishIcon(line.finish!),
                      ),
                  ],
                ),
                MainText(
                  '${formatMoney(line.unitPrice)} ${l10n.currency_egp} · ${quantityLabel(context, line.unit, line.quantity)}',
                  fontSize: 12.5,
                  color: t.subText,
                ),
              ],
            ),
          ),
          MainText(
            '${formatMoney(line.total)} ${l10n.currency_egp}',
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: t.text,
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  final OrderPricing pricing;

  const _TotalsCard({required this.pricing});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    String money(double v) => '${formatMoney(v)} ${l10n.currency_egp}';

    Widget row(String label, String value, {Color? valueColor}) => Row(
      children: [
        Expanded(child: MainText(label, fontSize: 13.5, color: t.subText)),
        MainText(
          value,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: valueColor ?? t.text,
        ),
      ],
    );

    return LavelleCard(
      child: Column(
        spacing: 12,
        children: [
          row(l10n.subtotal, money(pricing.subtotal)),
          if (pricing.discount != null)
            row(
              l10n.discount,
              '- ${money(pricing.discount!)}',
              valueColor: MyColors.success,
            ),
          if (pricing.deliveryFee != null)
            row(l10n.delivery_fee, money(pricing.deliveryFee!)),
          Divider(height: 1, color: t.border),
          Row(
            children: [
              Expanded(
                child: MainText(
                  kPriceIsEstimate ? l10n.estimated_total : l10n.order_total,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
              ),
              MainText(
                money(pricing.total),
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: t.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  final OrderPricing pricing;

  const _ContinueBar({required this.pricing});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        border: Border(top: BorderSide(color: t.border)),
        boxShadow: [
          BoxShadow(
            color: t.shadow,
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            spacing: 14,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    MainText(
                      kPriceIsEstimate
                          ? l10n.estimated_total
                          : l10n.order_total,
                      fontSize: 11.5,
                      color: t.subText,
                    ),
                    MainText(
                      '${formatMoney(pricing.total)} ${l10n.currency_egp}',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: t.accent,
                    ),
                  ],
                ),
              ),
              LavelleButton(
                title: l10n.continue_label,
                icon: Icons.arrow_forward_rounded,
                expand: false,
                height: 50,
                onTap: () {
                  // TODO(خطوة 8): افتح اختيار عنوان الاستلام
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Step 8 · Address selection — next step'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

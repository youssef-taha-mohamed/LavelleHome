import '../../../../shared/widgets/shared_widgets.dart';
import '../../../laundry/data/laundry_details.dart';
import '../../../laundry/data/module/laundry_model.dart';
import '../../../laundry/presentation/view/widgets/laundry_details_section.dart';
import '../../domain/order_config.dart';
import '../cubit/order_draft_cubit.dart';
import '../order_formatters.dart';
import 'widgets/measure_sheet.dart';
import 'order_summary_screen.dart';

/// يبدأ طلباً من المغسلة (يهيّئ المسودة) ثم يفتح شاشة اختيار الخدمات.
/// [details] هي التفاصيل المحمّلة بالفعل من شاشة تفاصيل المغسلة.
Future<void> openServiceSelection(
  BuildContext context, {
  required LaundryDetails details,
}) {
  context.read<OrderDraftCubit>().start(
    laundryId: details.summary.id,
    laundryName: details.summary.name,
    deliveryFee: details.deliveryFee,
  );
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ServiceSelectionScreen(details: details)),
  );
}

class ServiceSelectionScreen extends StatelessWidget {
  final LaundryDetails details;

  const ServiceSelectionScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final l10n = context.l10n;
    final groups = details.serviceGroups;

    return Scaffold(
      bottomNavigationBar: groups.isEmpty ? null : const _SummaryBar(),
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
                    l10n.select_services,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  MainText(
                    '${l10n.ordering_from} ${details.summary.name}',
                    fontSize: 13.5,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 30),
                  if (groups.isEmpty)
                    LavelleStateView(
                      icon: Icons.local_laundry_service_outlined,
                      title: l10n.services_not_listed,
                    )
                  else ...[
                    if (kPriceIsEstimate) ...[
                      NoticeBanner(
                        icon: Icons.info_outline_rounded,
                        text: l10n.price_estimate_note,
                        color: LavelleTheme.of(context).accent,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _ServiceSections(groups: groups),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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

// ═════════════════════════════════════════════════════════════
// مجموعة خدمة + أصنافها
// ═════════════════════════════════════════════════════════════

class _GroupCard extends StatelessWidget {
  final ServiceGroup group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    // عدد الأصناف المختارة من هذه المجموعة (للشارة بجوار الاسم)
    final selectedCount = context.select<OrderDraftCubit, int>(
      (c) => c.state.lines.values.where((l) => l.groupId == group.id).length,
    );

    return LavelleCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              LavelleIconBadge(
                icon: group.type?.icon ?? Icons.local_laundry_service_rounded,
                size: 40,
                filled: false,
              ),
              Expanded(
                child: MainText(
                  group.name,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
              ),
              if (selectedCount > 0)
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LavelleGradients.primary,
                  ),
                  child: MainText(
                    '$selectedCount',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          if (group.hasFinishChoice) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: MainText(
                context.l10n.finish_choice_hint,
                fontSize: 12,
                color: t.subText,
              ),
            ),
          ],
          const SizedBox(height: 6),
          for (var i = 0; i < group.items.length; i++) ...[
            Divider(height: 1, color: t.border.withValues(alpha: 0.6)),
            _ItemRow(group: group, item: group.items[i]),
          ],
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final ServiceGroup group;
  final PriceItem item;

  const _ItemRow({required this.group, required this.item});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    // قطع الخدمات التي فيها كي: تعليق أو تطبيق لكل قطعة
    if (group.hasFinishChoice && item.unit == PricingUnit.piece) {
      return _FinishItemRow(group: group, item: item);
    }

    final cubit = context.read<OrderDraftCubit>();
    final key = OrderDraftCubit.keyOf(group, item);
    final qty = context.select<OrderDraftCubit, double>(
      (c) => c.state.quantityOf(key),
    );

    void openMeasure() => showMeasureSheet(
      context,
      item: item,
      initial: qty,
      onSave: (v) => cubit.setQuantity(group, item, v),
    );

    final Widget control;
    if (item.unit == PricingUnit.piece) {
      control = qty == 0
          ? _AddButton(onTap: () => cubit.increment(group, item))
          : _Stepper(
              quantity: qty.round(),
              onIncrement: () => cubit.increment(group, item),
              onDecrement: () => cubit.decrement(group, item),
            );
    } else {
      control = qty == 0
          ? _AddButton(onTap: openMeasure)
          : _MeasureChip(
              label: quantityLabel(context, item.unit, qty),
              onTap: openMeasure,
            );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                MainText(
                  item.name,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: t.text,
                ),
                MainText(
                  '${formatMoney(item.price)} ${l10n.currency_egp} · ${pricingUnitLabel(context, item.unit)}',
                  fontSize: 12,
                  color: t.subText,
                ),
              ],
            ),
          ),
          control,
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// أزرار الكمية
// ═════════════════════════════════════════════════════════════

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LavelleGradients.primary,
        ),
        child: InkWell(
          onTap: onTap,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _Stepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    Widget button(IconData icon, VoidCallback onTap) => InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: 38,
        child: Icon(icon, size: 20, color: t.accent),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: t.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, onDecrement),
          SizedBox(
            width: 28,
            child: Center(
              child: MainText(
                '$quantity',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: t.text,
              ),
            ),
          ),
          button(Icons.add_rounded, onIncrement),
        ],
      ),
    );
  }
}

/// كمية الصنف المسعّر بالوزن/المساحة، والضغط عليها يعدّلها
class _MeasureChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MeasureChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: t.accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: t.accent.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            MainText(
              label,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: t.accent,
            ),
            Icon(Icons.edit_outlined, size: 15, color: t.accent),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// الشريط السفلي: العدد + الإجمالي + مراجعة الطلب
// ═════════════════════════════════════════════════════════════

class _SummaryBar extends StatelessWidget {
  const _SummaryBar();

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return BlocBuilder<OrderDraftCubit, OrderDraftState>(
      builder: (context, draft) {
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
                    child: draft.isEmpty
                        ? MainText(
                            l10n.select_services_hint,
                            fontSize: 13,
                            color: t.subText,
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              MainText(
                                '${kPriceIsEstimate ? l10n.estimated_total : l10n.order_total} · ${l10n.items_label} ${draft.lineCount}',
                                fontSize: 11.5,
                                color: t.subText,
                              ),
                              MainText(
                                '${formatMoney(draft.subtotal)} ${l10n.currency_egp}',
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: t.accent,
                              ),
                            ],
                          ),
                  ),
                  LavelleButton(
                    title: l10n.review_order,
                    icon: Icons.arrow_forward_rounded,
                    expand: false,
                    height: 50,
                    isDimmed: draft.isEmpty,
                    onTap: () {
                      if (draft.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.select_services_first)),
                        );
                        return;
                      }
                      openOrderSummary(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════
// الأقسام: ملابس / سجاد (الطلب قد يضم النوعين معاً)
// ═════════════════════════════════════════════════════════════

/// يعرض كل خدمات المغسلة. لو فيها ملابس وسجاد معاً، تُقسَّم تحت عنوانين،
/// لأن النوع يحدد وسيلة الاستلام المناسبة. ويمكن للعميل اختيار النوعين في طلب واحد.
class _ServiceSections extends StatelessWidget {
  final List<ServiceGroup> groups;

  const _ServiceSections({required this.groups});

  @override
  Widget build(BuildContext context) {
    final kinds = OrderKind.values
        .where((k) => groups.any((g) => g.kind == k))
        .toList();
    final showHeaders = kinds.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        for (final k in kinds) ...[
          if (showHeaders) _KindHeader(kind: k),
          for (final g in groups)
            if (g.kind == k) _GroupCard(group: g),
        ],
      ],
    );
  }
}

class _KindHeader extends StatelessWidget {
  final OrderKind kind;

  const _KindHeader({required this.kind});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Row(
      spacing: 10,
      children: [
        LavelleIconBadge(icon: orderKindIcon(kind), size: 34),
        MainText(
          orderKindLabel(context, kind),
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: t.accent,
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
// قطعة بكي: تعليق أو تطبيق لكل قطعة
// ═════════════════════════════════════════════════════════════

class _FinishItemRow extends StatelessWidget {
  final ServiceGroup group;
  final PriceItem item;

  const _FinishItemRow({required this.group, required this.item});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    final def = item.defaultFinish;

    // الافتراضي أولاً، ويستطيع العميل استخدام الآخر
    final order = def == GarmentFinish.folded
        ? const [GarmentFinish.folded, GarmentFinish.hanging]
        : const [GarmentFinish.hanging, GarmentFinish.folded];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              MainText(
                item.name,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: t.text,
              ),
              MainText(
                '${formatMoney(item.price)} ${l10n.currency_egp} · ${pricingUnitLabel(context, item.unit)}',
                fontSize: 12,
                color: t.subText,
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              for (final f in order)
                Expanded(
                  child: _FinishCounter(
                    group: group,
                    item: item,
                    finish: f,
                    isDefault: f == def,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinishCounter extends StatelessWidget {
  final ServiceGroup group;
  final PriceItem item;
  final GarmentFinish finish;
  final bool isDefault;

  const _FinishCounter({
    required this.group,
    required this.item,
    required this.finish,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final cubit = context.read<OrderDraftCubit>();
    final key = OrderDraftCubit.keyOf(group, item, finish);
    final qty = context.select<OrderDraftCubit, double>(
      (c) => c.state.quantityOf(key),
    );
    final active = qty > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: t.accent.withValues(alpha: active ? 0.1 : 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: t.accent.withValues(alpha: active ? 0.5 : 0.18),
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(garmentFinishIcon(finish), size: 18, color: t.accent),
                MainText(
                  garmentFinishLabel(context, finish),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.text,
                ),
                if (isDefault)
                  MainText(
                    context.l10n.finish_default,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: t.subText,
                  ),
              ],
            ),
          ),
          qty == 0
              ? _AddButton(
                  onTap: () => cubit.increment(group, item, finish: finish),
                )
              : _Stepper(
                  quantity: qty.round(),
                  onIncrement: () =>
                      cubit.increment(group, item, finish: finish),
                  onDecrement: () =>
                      cubit.decrement(group, item, finish: finish),
                ),
        ],
      ),
    );
  }
}

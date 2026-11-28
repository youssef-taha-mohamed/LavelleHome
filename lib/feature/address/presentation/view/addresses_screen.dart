import '../../../../shared/widgets/shared_widgets.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../order/presentation/cubit/order_draft_cubit.dart';
import '../../domain/entities/address.dart';
import '../widgets/address_labels.dart';
import 'address_edit_screen.dart';

enum AddressesMode { select, manage }

Future<void> openAddressSelection(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AddressesScreen(mode: AddressesMode.select),
    ),
  );
}

Future<void> openAddressesManage(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AddressesScreen(mode: AddressesMode.manage),
    ),
  );
}

class AddressesScreen extends StatefulWidget {
  final AddressesMode mode;

  const AddressesScreen({super.key, required this.mode});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  bool get _isSelect => widget.mode == AddressesMode.select;

  @override
  void initState() {
    super.initState();
    if (_isSelect) {
      // نبدأ بالعنوان المختار حالياً (لو كان محفوظاً) كعنوان استلام
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final draft = context.read<OrderDraftCubit>();
        final current = context.read<LocationCubit>().state.selected?.address;
        if (draft.state.pickupAddress == null && current != null) {
          draft.setPickupAddress(current);
        }
      });
    }
  }

  Future<void> _openEdit([SavedAddress? address]) async {
    final draft = context.read<OrderDraftCubit>();
    final saved = await openAddressEdit(context, address: address);
    // عنوان جديد أُضيف أثناء الطلب: يصبح عنوان الاستلام
    if (saved != null && address == null && _isSelect) {
      draft.setPickupAddress(saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topInset = MediaQuery.of(context).padding.top;
    final pickupId = context.select<OrderDraftCubit, String?>(
      (c) => c.state.pickupAddress?.id,
    );

    return Scaffold(
      bottomNavigationBar: _isSelect ? const _ContinueBar() : null,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LavelleHeroBackground(
                height: topInset + (_isSelect ? 175 : 150),
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  MainText(
                    _isSelect ? l10n.pickup_address : l10n.my_addresses,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  if (_isSelect) ...[
                    const SizedBox(height: 6),
                    MainText(
                      l10n.pickup_address_hint,
                      fontSize: 13.5,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ],
                  const SizedBox(height: 30),
                  BlocBuilder<LocationCubit, LocationState>(
                    buildWhen: (a, b) =>
                        a.addresses != b.addresses ||
                        a.isLoading != b.isLoading,
                    builder: (context, loc) {
                      if (loc.isLoading) {
                        return const LavelleSkeletonList(itemCount: 2);
                      }

                      if (loc.addresses.isEmpty) {
                        return LavelleStateView(
                          icon: Icons.location_off_outlined,
                          title: l10n.no_saved_addresses,
                          message: l10n.add_address_to_order,
                          actionLabel: l10n.add_new_address,
                          onAction: _openEdit,
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 12,
                        children: [
                          for (final a in loc.addresses)
                            _AddressCard(
                              address: a,
                              showRadio: _isSelect,
                              selected: _isSelect && a.id == pickupId,
                              onTap: () => _isSelect
                                  ? context
                                        .read<OrderDraftCubit>()
                                        .setPickupAddress(a)
                                  : _openEdit(a),
                              onEdit: () => _openEdit(a),
                            ),
                          const SizedBox(height: 4),
                          LavelleButton(
                            title: l10n.add_new_address,
                            icon: Icons.add_rounded,
                            variant: LavelleButtonVariant.secondary,
                            onTap: _openEdit,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final SavedAddress address;
  final bool showRadio;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _AddressCard({
    required this.address,
    required this.showRadio,
    required this.selected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final area = address.data.area;

    return LavelleCard(
      padding: const EdgeInsets.all(12),
      borderColor: selected ? t.accent.withValues(alpha: 0.6) : null,
      onTap: onTap,
      child: Row(
        children: [
          LavelleIconBadge(
            icon: addressAreaIcon(area),
            size: 44,
            filled: false,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                MainText(
                  addressAreaLabel(context, area),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
                MainText(
                  address.formatted,
                  fontSize: 13,
                  color: t.subText,
                  textDirection: area == AddressArea.madinaty
                      ? TextDirection.ltr
                      : Directionality.of(context),
                ),
              ],
            ),
          ),
          if (showRadio) ...[
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit_outlined, size: 20, color: t.subText),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? t.accent : t.subText.withValues(alpha: 0.5),
            ),
          ] else
            Icon(Icons.chevron_right_rounded, color: t.subText),
        ],
      ),
    );
  }
}

/// الشريط السفلي في وضع الاختيار: العنوان المختار + متابعة
class _ContinueBar extends StatelessWidget {
  const _ContinueBar();

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    final address = context.select<OrderDraftCubit, SavedAddress?>(
      (c) => c.state.pickupAddress,
    );

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    MainText(
                      l10n.selected_address,
                      fontSize: 11.5,
                      color: t.subText,
                    ),
                    MainText(
                      address == null
                          ? l10n.select_address_first
                          : addressShortLabel(context, address.data),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: address == null ? t.subText : t.text,
                    ),
                  ],
                ),
              ),
              LavelleButton(
                title: l10n.continue_label,
                icon: Icons.arrow_forward_rounded,
                expand: false,
                height: 50,
                isDimmed: address == null,
                onTap: () {
                  if (address == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.select_address_first)),
                    );
                    return;
                  }
                  // TODO(خطوة 9): افتح الدفع وتأكيد الطلب
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Step 9 · Checkout — next step'),
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

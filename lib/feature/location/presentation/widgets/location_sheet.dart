import '../../../../shared/widgets/shared_widgets.dart';
import '../../../address/domain/entities/address.dart';
import '../../../address/presentation/widgets/address_labels.dart';
import '../cubit/location_cubit.dart';
import 'address_form.dart';

Future<void> showLocationSheet(BuildContext context) {
  // نلتقط الـ cubit لأن الـ Sheet تُفتح فوق الـ Navigator
  final cubit = context.read<LocationCubit>();
  return showLavelleSheet<void>(
    context,
    title: context.l10n.choose_location,
    builder: (_) =>
        BlocProvider.value(value: cubit, child: const _LocationSheetBody()),
  );
}

enum _SheetMode { list, add }

class _LocationSheetBody extends StatefulWidget {
  const _LocationSheetBody();

  @override
  State<_LocationSheetBody> createState() => _LocationSheetBodyState();
}

class _LocationSheetBodyState extends State<_LocationSheetBody> {
  _SheetMode _mode = _SheetMode.list;
  final _formKey = GlobalKey<FormState>();
  AddressData _draft = const AddressData();
  bool _saving = false;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false) || !_draft.isValid) {
      return;
    }
    final cubit = context.read<LocationCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final errorText = context.l10n.error_message;

    setState(() => _saving = true);
    try {
      await cubit.addAddress(_draft);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(errorText)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      child: _mode == _SheetMode.list
          ? _buildList(context)
          : _buildAdd(context),
    );
  }

  // ───────────────────────── القائمة ─────────────────────────

  Widget _buildList(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);
    final cubit = context.read<LocationCubit>();

    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final blocked =
            state.permission == LocationPermissionStatus.denied ||
            state.permission == LocationPermissionStatus.deniedForever ||
            state.permission == LocationPermissionStatus.serviceDisabled;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // استخدام الموقع الحالي
            _CurrentLocationTile(
              isLocating: state.isLocating,
              isSelected: state.selected?.isCurrentPosition ?? false,
              onTap: () async {
                final ok = await cubit.useCurrentLocation();
                if (ok && context.mounted) Navigator.pop(context);
              },
            ),

            if (blocked) ...[
              const SizedBox(height: 12),
              _PermissionBanner(
                status: state.permission,
                onRetry: cubit.useCurrentLocation,
                onOpenSettings: cubit.openSettings,
              ),
            ],
            if (state.locateFailed) ...[
              const SizedBox(height: 10),
              MainText(
                l10n.location_unavailable,
                fontSize: 12.5,
                color: LavelleTheme.of(context).subText,
              ),
            ],

            const SizedBox(height: 22),
            MainText(
              l10n.my_addresses,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: t.text,
            ),
            const SizedBox(height: 10),

            if (state.addresses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: MainText(
                  l10n.no_saved_addresses,
                  fontSize: 13,
                  color: t.subText,
                ),
              )
            else
              for (final a in state.addresses)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AddressTile(
                    address: a,
                    selected: state.selected?.address?.id == a.id,
                    onTap: () async {
                      await cubit.selectAddress(a);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),

            const SizedBox(height: 8),
            LavelleButton(
              title: l10n.add_new_address,
              icon: Icons.add_rounded,
              variant: LavelleButtonVariant.secondary,
              onTap: () => setState(() => _mode = _SheetMode.add),
            ),
          ],
        );
      },
    );
  }

  // ───────────────────────── إضافة عنوان ─────────────────────────

  Widget _buildAdd(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _mode = _SheetMode.list),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: t.text,
                ),
              ),
            ),
            const SizedBox(width: 6),
            MainText(
              l10n.new_address,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: t.text,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: AddressForm(
            initial: _draft,
            onChanged: (d) => setState(() => _draft = d),
          ),
        ),
        const SizedBox(height: 22),
        LavelleButton(
          title: l10n.save_and_use_address,
          icon: Icons.check_rounded,
          isDimmed: !_draft.isValid,
          isLoading: _saving,
          onTap: _save,
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
// عناصر القائمة
// ═════════════════════════════════════════════════════════════

class _CurrentLocationTile extends StatelessWidget {
  final bool isLocating;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrentLocationTile({
    required this.isLocating,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return LavelleCard(
      padding: const EdgeInsets.all(14),
      borderColor: isSelected ? t.accent.withValues(alpha: 0.6) : null,
      onTap: isLocating ? null : onTap,
      child: Row(
        children: [
          const LavelleIconBadge(icon: Icons.my_location_rounded, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                MainText(
                  l10n.use_current_location,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
                MainText(
                  l10n.use_current_location_hint,
                  fontSize: 12.5,
                  color: t.subText,
                ),
              ],
            ),
          ),
          if (isLocating)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: t.accent,
              ),
            )
          else if (isSelected)
            Icon(Icons.check_circle_rounded, color: t.accent),
        ],
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  final LocationPermissionStatus status;
  final Future<bool> Function() onRetry;
  final Future<void> Function() onOpenSettings;

  const _PermissionBanner({
    required this.status,
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);

    final String message;
    final String action;
    final bool opensSettings;

    switch (status) {
      case LocationPermissionStatus.deniedForever:
        message = l10n.location_permission_forever;
        action = l10n.open_settings;
        opensSettings = true;
        break;
      case LocationPermissionStatus.serviceDisabled:
        message = l10n.location_service_disabled;
        action = l10n.open_settings;
        opensSettings = true;
        break;
      default:
        message = l10n.location_permission_denied;
        action = l10n.try_again;
        opensSettings = false;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MyColors.warning600.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.warning600.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const Icon(
                Icons.location_off_outlined,
                color: MyColors.warning600,
                size: 22,
              ),
              Expanded(child: MainText(message, fontSize: 13, color: t.text)),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => opensSettings ? onOpenSettings() : onRetry(),
              child: MainText(
                action,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: t.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final SavedAddress address;
  final bool selected;
  final VoidCallback onTap;

  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
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
            size: 42,
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
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                ),
                MainText(
                  address.formatted,
                  fontSize: 12.5,
                  color: t.subText,
                  textDirection: area == AddressArea.madinaty
                      ? TextDirection.ltr
                      : Directionality.of(context),
                ),
              ],
            ),
          ),
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? t.accent : t.subText.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

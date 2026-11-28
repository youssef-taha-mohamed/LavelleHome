import '../../../../shared/widgets/shared_widgets.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../location/presentation/widgets/address_form.dart';
import '../../../order/presentation/cubit/order_draft_cubit.dart';
import '../../domain/entities/address.dart';

/// يفتح شاشة إضافة عنوان (address = null) أو تعديله.
/// يرجع العنوان المحفوظ، أو null لو أُلغيت العملية أو حُذف العنوان.
Future<SavedAddress?> openAddressEdit(
  BuildContext context, {
  SavedAddress? address,
}) {
  return Navigator.push<SavedAddress>(
    context,
    MaterialPageRoute(builder: (_) => AddressEditScreen(address: address)),
  );
}

class AddressEditScreen extends StatefulWidget {
  final SavedAddress? address;

  const AddressEditScreen({super.key, this.address});

  @override
  State<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends State<AddressEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late AddressData _draft = widget.address?.data ?? const AddressData();
  bool _saving = false;

  bool get _isEditing => widget.address != null;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false) || !_draft.isValid) {
      return;
    }

    final location = context.read<LocationCubit>();
    final order = context.read<OrderDraftCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final errorText = context.l10n.error_message;

    setState(() => _saving = true);
    try {
      // عنوان جديد من هنا لا يغيّر موقع تصفح الرئيسية (select: false)
      final saved = _isEditing
          ? await location.updateAddress(widget.address!.id, _draft)
          : await location.addAddress(_draft, select: false);

      // لو هو عنوان الاستلام الحالي للطلب، حدّثه
      if (order.state.pickupAddress?.id == saved.id) {
        order.setPickupAddress(saved);
      }
      if (mounted) Navigator.pop(context, saved);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(errorText)));
    }
  }

  Future<void> _delete() async {
    final location = context.read<LocationCubit>();
    final order = context.read<OrderDraftCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final errorText = context.l10n.error_message;
    final id = widget.address!.id;

    final ok = await showLavelleSheet<bool>(
      context,
      title: context.l10n.delete_address,
      builder: (_) => const _ConfirmDelete(),
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      await location.deleteAddress(id);
      if (order.state.pickupAddress?.id == id) order.setPickupAddress(null);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(errorText)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LavelleHeroBackground(
                  height: topInset + 140,
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
                    const SizedBox(height: 12),
                    MainText(
                      _isEditing ? l10n.edit_address : l10n.new_address,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 26),
                    LavelleCard(
                      padding: const EdgeInsets.all(18),
                      child: Form(
                        key: _formKey,
                        child: AddressForm(
                          initial: _draft,
                          onChanged: (d) => setState(() => _draft = d),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LavelleButton(
                      title: l10n.save_address,
                      icon: Icons.check_rounded,
                      isDimmed: !_draft.isValid,
                      isLoading: _saving,
                      onTap: _save,
                    ),
                    if (_isEditing) ...[
                      const SizedBox(height: 6),
                      Center(
                        child: TextButton(
                          onPressed: _saving ? null : _delete,
                          child: MainText(
                            l10n.delete_address,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmDelete extends StatelessWidget {
  const _ConfirmDelete();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainText(l10n.delete_address_message, fontSize: 14, color: t.subText),
          const SizedBox(height: 20),
          LavelleButton(
            title: l10n.delete,
            onTap: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: MainText(
              l10n.cancel,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: t.subText,
            ),
          ),
        ],
      ),
    );
  }
}

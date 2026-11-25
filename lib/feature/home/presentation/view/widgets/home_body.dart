import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../data/home_model.dart';
import '../../cubits/home_cubit.dart';
import 'banner_widget.dart';
import 'lundry_card.dart';

class HomeBody extends StatelessWidget {
  final HomeState state;

  const HomeBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    switch (state.status) {
      case LavelleViewStatus.loading:
        return const _HomeSkeleton();

      case LavelleViewStatus.error:
        return LavelleErrorView(onRetry: cubit.load);

      case LavelleViewStatus.noConnection:
        return LavelleErrorView(onRetry: cubit.load, isNoConnection: true);

      case LavelleViewStatus.empty:
      case LavelleViewStatus.success:
        if (state.needsLocation) {
          return LavelleStateView(
            icon: Icons.location_searching_rounded,
            title: context.l10n.location_prompt_title,
            message: context.l10n.location_prompt_message,
            actionLabel: context.l10n.select_location,
            // TODO(خطوة 2): افتح showLocationSheet(context)
            onAction: () => _comingSoon(context, 'Step 2 · Location sheet'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 22,
          children: [
            if (state.banners.isNotEmpty)
              BannerCarousel(banners: state.banners),
            _ServiceCategories(
              selected: state.selectedService,
              onSelect: cubit.selectService,
            ),
            _NearbySection(state: state),
          ],
        );
    }
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 22,
      children: [
        const LavelleSkeleton(width: double.infinity, height: 142, radius: 24),
        Row(
          spacing: 10,
          children: [
            for (var i = 0; i < 4; i++)
              const Expanded(child: LavelleSkeleton(height: 86, radius: 20)),
          ],
        ),
        const LavelleSkeletonList(itemCount: 3),
      ],
    );
  }
}

class _ServiceCategories extends StatelessWidget {
  final LaundryServiceType? selected;
  final ValueChanged<LaundryServiceType?> onSelect;

  const _ServiceCategories({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          LavelleSectionHeader(title: context.l10n.home_services_title),
          Row(
            spacing: 10,
            children: [
              for (final type in LaundryServiceType.values)
                Expanded(
                  child: _CategoryTile(
                    type: type,
                    selected: selected == type,
                    onTap: () => onSelect(type),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final LaundryServiceType type;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final radius = BorderRadius.circular(20);

    return InkWell(
      borderRadius: radius,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            height: 62,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: selected ? LavelleGradients.primary : null,
              color: selected ? null : t.card,
              border: Border.all(
                color: selected ? Colors.transparent : t.border,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: MyColors.primaryColor.withValues(alpha: 0.32),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              type.icon,
              size: 28,
              color: selected ? Colors.white : t.accent,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: MainText(
              laundryServiceLabel(context, type),
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? t.accent : t.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// المغاسل القريبة
// ═════════════════════════════════════════════════════════════

class _NearbySection extends StatelessWidget {
  final HomeState state;

  const _NearbySection({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<HomeCubit>();
    final list = state.visibleLaundries;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          LavelleSectionHeader(
            title: l10n.nearby_laundries,
            actionLabel: l10n.map_view,
            // TODO(خطوة 5): Navigator.pushNamed(map)
            onAction: () => _comingSoon(context, 'Step 5 · Map'),
          ),
          if (list.isEmpty)
            state.selectedService != null
                ? LavelleStateView(
                    icon: Icons.search_off_rounded,
                    title: l10n.no_laundries_for_service,
                    actionLabel: l10n.clear_filter,
                    onAction: () => cubit.selectService(null),
                  )
                : LavelleStateView(
                    icon: Icons.storefront_outlined,
                    title: l10n.no_laundries_nearby,
                    message: l10n.no_laundries_nearby_message,
                    // TODO(خطوة 2): تغيير الموقع
                    actionLabel: l10n.select_location,
                    onAction: () =>
                        _comingSoon(context, 'Step 2 · Location sheet'),
                  )
          else
            Column(
              spacing: 12,
              children: [
                for (final laundry in list)
                  LaundryCard(
                    laundry: laundry,
                    // TODO(خطوة 4): افتح تفاصيل المغسلة laundry.id
                    onTap: () =>
                        _comingSoon(context, 'Step 4 · Laundry details'),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

void _comingSoon(BuildContext context, String step) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$step — next step')));
}

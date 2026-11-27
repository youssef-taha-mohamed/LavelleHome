import '../../../../shared/widgets/shared_widgets.dart';
import '../../data/home_model.dart';
import '../../domain/laundry_details_repo.dart';
import '../cubits/laundry_details/laundry_details_cubit.dart';
import 'widgets/external_map.dart';
import 'widgets/laundry_details_section.dart';
import 'widgets/lundry_card.dart';

Future<void> openLaundryDetails(
  BuildContext context, {
  required String id,
  Laundry? preview,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => LaundryDetailsScreen(laundryId: id, preview: preview),
    ),
  );
}

class LaundryDetailsScreen extends StatelessWidget {
  final String laundryId;
  final Laundry? preview;

  const LaundryDetailsScreen({
    super.key,
    required this.laundryId,
    this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LaundryDetailsCubit(
        const MockLaundryDetailsRepository(),
        laundryId,
        preview: preview,
      )..load(),
      child: const _DetailsView(),
    );
  }
}

void _comingSoon(BuildContext context, String step) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$step — next step')));
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return BlocBuilder<LaundryDetailsCubit, LaundryDetailsState>(
      builder: (context, state) {
        final summary = state.summary;

        return Scaffold(
          bottomNavigationBar: summary == null
              ? null
              : _StartOrderBar(laundry: summary),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LavelleHeroBackground(
                    height: topInset + 210,
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
                      const SizedBox(height: 36),
                      if (summary != null)
                        _HeaderCard(
                          laundry: summary,
                          description: state.details?.description,
                        )
                      else if (state.status == LavelleViewStatus.loading)
                        const LavelleSkeleton(
                          width: double.infinity,
                          height: 130,
                          radius: 20,
                        ),
                      const SizedBox(height: 22),
                      _DetailsBody(state: state),
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

// ═════════════════════════════════════════════════════════════
// الهيدر: الشعار + الاسم + التقييم + المسافة + الحالة
// ═════════════════════════════════════════════════════════════

class _HeaderCard extends StatelessWidget {
  final Laundry laundry;
  final String? description;

  const _HeaderCard({required this.laundry, this.description});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    final l = laundry;
    final chip = laundryStatusChip(context, l.status);

    return LavelleCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaundryLogo(name: l.name, url: l.logoUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 7,
                  children: [
                    MainText(
                      l.name,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: t.text,
                    ),
                    if (l.rating != null)
                      LavelleRatingBadge(
                        rating: l.rating!,
                        count: l.ratingCount,
                      ),
                    if (l.area != null || l.distanceKm != null)
                      Wrap(
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (l.area != null)
                            MainText(
                              l.area!,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: t.subText,
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
                    ?chip,
                  ],
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: t.border),
            const SizedBox(height: 12),
            MainText(description!, fontSize: 13.5, color: t.subText),
          ],
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// المحتوى حسب الحالة
// ═════════════════════════════════════════════════════════════

class _DetailsBody extends StatelessWidget {
  final LaundryDetailsState state;

  const _DetailsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LaundryDetailsCubit>();
    final l10n = context.l10n;

    switch (state.status) {
      case LavelleViewStatus.loading:
        return const LavelleSkeletonList(itemCount: 2);
      case LavelleViewStatus.error:
        return LavelleErrorView(onRetry: cubit.load);
      case LavelleViewStatus.noConnection:
        return LavelleErrorView(onRetry: cubit.load, isNoConnection: true);
      case LavelleViewStatus.empty:
      case LavelleViewStatus.success:
        final d = state.details!;
        final location = d.location;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 22,
          children: [
            if (d.summary.status == LaundryStatus.closed)
              NoticeBanner(
                icon: Icons.schedule_rounded,
                text: l10n.laundry_closed_notice,
                color: MyColors.error,
              ),
            if (d.summary.status == LaundryStatus.unavailable)
              NoticeBanner(
                icon: Icons.pause_circle_outline_rounded,
                text: l10n.laundry_unavailable_notice,
                color: MyColors.warning600,
              ),
            DetailsSection(
              title: l10n.services_and_prices,
              child: ServicesSection(groups: d.serviceGroups),
            ),
            DetailsSection(
              title: l10n.working_hours,
              child: HoursSection(
                hours: d.workingHours,
                status: d.summary.status,
              ),
            ),
            DetailsSection(
              title: l10n.location,
              child: LocationSection(
                address: d.address,
                hasCoordinates: location != null,
                // TODO(خطوة 5): افتح الخريطة الكاملة على هذه المغسلة
                onOpenMap: () => _comingSoon(context, 'Step 5 · Map'),
                onDirections: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final failText = l10n.cannot_open_maps;
                  final ok = await openExternalDirections(location!);
                  if (!ok) {
                    messenger.showSnackBar(SnackBar(content: Text(failText)));
                  }
                },
              ),
            ),
            if (d.offers.isNotEmpty)
              DetailsSection(
                title: l10n.offers_title,
                child: OffersSection(
                  offers: d.offers,
                  // TODO(خطوة 18): تفاصيل خطة الاشتراك
                  onOfferTap: (_) =>
                      _comingSoon(context, 'Step 18 · Subscription plan'),
                ),
              ),
          ],
        );
    }
  }
}

// ═════════════════════════════════════════════════════════════
// الشريط السفلي: ابدأ الطلب
// ═════════════════════════════════════════════════════════════

class _StartOrderBar extends StatelessWidget {
  final Laundry laundry;

  const _StartOrderBar({required this.laundry});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;
    final unavailable = laundry.status == LaundryStatus.unavailable;

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
                      l10n.ordering_from,
                      fontSize: 11.5,
                      color: t.subText,
                    ),
                    MainText(
                      laundry.name,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: t.text,
                    ),
                  ],
                ),
              ),
              LavelleButton(
                title: l10n.start_order,
                icon: Icons.arrow_forward_rounded,
                expand: false,
                height: 50,
                isDimmed: unavailable,
                onTap: () {
                  if (unavailable) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.laundry_unavailable_order)),
                    );
                    return;
                  }
                  // TODO(خطوة 6): افتح اختيار الخدمات لهذه المغسلة
                  _comingSoon(context, 'Step 6 · Service selection');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

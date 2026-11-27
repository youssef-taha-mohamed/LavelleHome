import 'dart:async';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../botttom_nav_bar/provider/nav_bar.dart';
import '../../../domain/repository/laundry_repository.dart';

class BannerCarousel extends StatefulWidget {
  final List<PromoBanner> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!_controller.hasClients) return;
        final next = (_page + 1) % widget.banners.length;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTap(PromoBanner b) {
    if (b.laundryId != null) {
      // TODO(خطوة 4): افتح تفاصيل المغسلة b.laundryId
      _comingSoon(context, 'Step 4 · Laundry details');
    } else {
      // بانر المنصة → تبويب العروض
      context.read<NavigationProvider>().changeIndex(NavTab.offers);
    }
  }

  /// أماكن ستُربط في الخطوات القادمة (مكتوب رقم الخطوة بجوار كل واحد)
  void _comingSoon(BuildContext context, String step) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$step — next step')));
  }

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => _BannerCard(
              banner: widget.banners[i],
              onTap: () => _onTap(widget.banners[i]),
            ),
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              for (var i = 0; i < widget.banners.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: i == _page ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? t.accent
                        : t.subText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final PromoBanner banner;
  final VoidCallback onTap;

  const _BannerCard({required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPlatform = banner.source == PromoSource.platform;
    final l10n = context.l10n;
    const radius = 24.0;

    // المنصة: كحلي الهوية. المغسلة: درجة تيل لتمييزها بصرياً
    final gradient = isPlatform
        ? LavelleGradients.primary
        : const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [MyColors.tertiary, Color(0xFF007A8C)],
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: gradient,
          // boxShadow: [
          //   BoxShadow(
          //     color: MyColors.primaryColor.withValues(alpha: 0.28),
          //     blurRadius: 20,
          //     offset: const Offset(0, 10),
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                children: [
                  PositionedDirectional(
                    top: -40,
                    end: -30,
                    child: _circle(130, 0.08),
                  ),
                  PositionedDirectional(
                    bottom: -50,
                    start: -20,
                    child: _circle(110, 0.06),
                  ),
                  if (banner.imageUrl != null)
                    PositionedDirectional(
                      top: 0,
                      bottom: 0,
                      end: 0,
                      width: 120,
                      child: Image.network(
                        banner.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // مصدر العرض: المنصة أو اسم المغسلة
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Icon(
                                isPlatform
                                    ? Icons.auto_awesome_rounded
                                    : Icons.storefront_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                              MainText(
                                isPlatform
                                    ? l10n.promo_platform
                                    : (banner.laundryName ?? ''),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        MainText(
                          banner.title,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        if (banner.subtitle != null) ...[
                          const SizedBox(height: 4),
                          MainText(
                            banner.subtitle!,
                            fontSize: 12.5,
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, double alpha) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: alpha),
    ),
  );
}

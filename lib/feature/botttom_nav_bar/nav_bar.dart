import 'dart:async';
import 'package:flutter/rendering.dart';
import '../../core/enums/enums.dart';
import '../../core/service/deep_link_service.dart';
import '../../core/utils/styles_link.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../home/presentation/view/home_screen.dart';
import 'provider/nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  static const String routeName = '/bottom-navigation';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool _canPop = false;
  Timer? _resetCanPopTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // التبويبات التي زارها المستخدم فقط تُبنى (تحميل كسول) وتحتفظ بحالتها
  final Set<int> _built = {NavTab.home};

  @override
  void initState() {
    super.initState();
    final provider = context.read<NavigationProvider>();
    provider.scaffoldKey = _scaffoldKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.reset();
      DeepLinkService.processPendingDeepLink();
    });
  }

  @override
  void dispose() {
    _resetCanPopTimer?.cancel();
    super.dispose();
  }

  /// استبدل كل Placeholder بالشاشة الحقيقية عند الوصول لخطوتها
  Widget _screenFor(int index, BuildContext context) {
    final l10n = context.l10n;
    switch (index) {
      case NavTab.home:
        return HomeScreen();
      case NavTab.orders:
        // TODO(خطوة 11): return const MyOrdersScreen();
        return _TabPlaceholder(
          icon: Icons.receipt_long_rounded,
          title: l10n.nav_my_orders,
          note: 'Step 11 · My Orders',
        );
      case NavTab.offers:
        // TODO(خطوة 16): return const OffersScreen();
        return _TabPlaceholder(
          icon: Icons.local_offer_rounded,
          title: l10n.nav_offers,
          note: 'Step 16 · Offers',
        );
      default:
        // TODO(خطوة 19): return const ProfileScreen();
        return _TabPlaceholder(
          icon: Icons.person_rounded,
          title: l10n.nav_profile,
          note: 'Step 19 · Profile',
        );
    }
  }

  void _onPopInvoked(bool didPop, NavigationProvider provider) {
    if (didPop) return;

    // من أي تبويب آخر: الرجوع للرئيسية أولاً
    if (provider.currentIndex != NavTab.home) {
      provider.changeIndex(NavTab.home);
      return;
    }

    // من الرئيسية: ضغطتان للخروج
    showToast(
      msg: context.l10n.back_gain,
      state: ToastedStates.warning,
      customColor: MyColors.primaryColor,
    );
    setState(() => _canPop = true);
    _resetCanPopTimer?.cancel();
    _resetCanPopTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _canPop = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NavigationProvider>();
    _built.add(provider.currentIndex);

    return ForceUpdateGuard(
      child: PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: (didPop, result) =>
            _onPopInvoked(didPop, provider),
        child: Scaffold(
          key: _scaffoldKey,
          body: NotificationListener<UserScrollNotification>(
            onNotification: (n) {
              // نتجاهل التمرير الأفقي (البانر والقوائم الأفقية)
              if (n.metrics.axis != Axis.vertical) return false;
              if (n.direction == ScrollDirection.forward) {
                provider.setBottomNavVisible(true);
              } else if (n.direction == ScrollDirection.reverse) {
                provider.setBottomNavVisible(false);
              }
              return false;
            },
            child: IndexedStack(
              index: provider.currentIndex,
              children: [
                for (var i = 0; i < NavTab.count; i++)
                  _built.contains(i)
                      ? _screenFor(i, context)
                      : const SizedBox.shrink(),
              ],
            ),
          ),
          bottomNavigationBar: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: provider.isBottomNavVisible
                ? _LavelleBottomBar(
                    currentIndex: provider.currentIndex,
                    ordersBadge: provider.activeOrdersCount,
                    onTap: provider.changeIndex,
                  )
                : const SizedBox(height: 0, width: double.infinity),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// شريط التنقل السفلي
// ═════════════════════════════════════════════════════════════

class _LavelleBottomBar extends StatelessWidget {
  final int currentIndex;
  final int ordersBadge;
  final ValueChanged<int> onTap;

  const _LavelleBottomBar({
    required this.currentIndex,
    required this.ordersBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    final items = <_NavItemData>[
      _NavItemData(Icons.home_outlined, Icons.home_rounded, l10n.home),
      _NavItemData(
        Icons.receipt_long_outlined,
        Icons.receipt_long_rounded,
        l10n.nav_my_orders,
        badge: ordersBadge,
      ),
      _NavItemData(
        Icons.local_offer_outlined,
        Icons.local_offer_rounded,
        l10n.nav_offers,
      ),
      _NavItemData(
        Icons.person_outline_rounded,
        Icons.person_rounded,
        l10n.nav_profile,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LavelleRadius.xl - 4),
        ),
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
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    data: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badge;

  const _NavItemData(this.icon, this.activeIcon, this.label, {this.badge = 0});
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width: selected ? 60 : 44,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: selected ? LavelleGradients.primary : null,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: MyColors.primaryColor.withValues(
                                alpha: 0.32,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    selected ? data.activeIcon : data.icon,
                    size: 22,
                    color: selected ? Colors.white : t.subText,
                  ),
                ),
                if (data.badge > 0)
                  PositionedDirectional(
                    top: -4,
                    end: -2,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: MyColors.goldAccent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: t.card, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: MainText(
                        data.badge > 9 ? '9+' : '${data.badge}',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: MyColors.navyColor,
                      ),
                    ),
                  ),
              ],
            ),
            MainText(
              data.label,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected ? t.accent : t.subText,
            ),
          ],
        ),
      ),
    );
  }
}

/// مكان مؤقت لكل تبويب حتى تُسلَّم شاشته الحقيقية
class _TabPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String note;

  const _TabPlaceholder({
    required this.icon,
    required this.title,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LavelleStateView(icon: icon, title: title, message: note),
    );
  }
}

import '../../../../shared/widgets/shared_widgets.dart';
import '../../../notifications/presentation/view/notification_screen.dart';
import '../../data/home_repo.dart';
import '../cubits/home_cubit.dart';
import 'widgets/home_body.dart';
import 'widgets/home_header.dart';

class HomeScreenParameter {
  final String id;

  HomeScreenParameter({required this.id});
}

class HomeScreen extends StatelessWidget {
  final HomeScreenParameter? parameter;

  static const String routeName = "/home";

  const HomeScreen({super.key, this.parameter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeCubit(const MockHomeRepository(scenario: HomeScenario.normal))
            ..load(),
      child: const _HomeView(),
    );
  }
}

/// أماكن ستُربط في الخطوات القادمة (مكتوب رقم الخطوة بجوار كل واحد)
void _comingSoon(BuildContext context, String step) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$step — next step')));
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final topInset = MediaQuery.of(context).padding.top;
    final heroHeight = topInset + 215;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: RefreshIndicator.adaptive(
        color: MyColors.primaryColor,
        edgeOffset: topInset + 60,
        onRefresh: () => cubit.load(silent: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LavelleHeroBackground(height: heroHeight),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, topInset + 12, 0, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: LavelleReveal(
                            child: HomeHeader(
                              locationLabel: state.locationLabel,
                              // TODO(خطوة 2): افتح showLocationSheet(context)
                              onLocationTap: () =>
                                  _comingSoon(context, 'Step 2 · Location sheet'),
                              onBellTap: () async {
                                if (!await ensureAuthenticated(context)) return;
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NotificationsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: LavelleReveal(
                            begin: 0.1,
                            child: _SearchRow(
                              // TODO(خطوة 3): Navigator.pushNamed(search)
                              onSearchTap: () =>
                                  _comingSoon(context, 'Step 3 · Search'),
                              // TODO(خطوة 5): Navigator.pushNamed(map)
                              onMapTap: () =>
                                  _comingSoon(context, 'Step 5 · Map'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        LavelleReveal(
                          begin: 0.25,
                          dy: 36,
                          child: HomeBody(state: state),
                        ),
                      ],
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

// ═════════════════════════════════════════════════════════════
// المحتوى حسب الحالة
// ═════════════════════════════════════════════════════════════

class _SearchRow extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onMapTap;

  const _SearchRow({required this.onSearchTap, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Material(
            color: t.card,
            borderRadius: BorderRadius.circular(LavelleRadius.md),
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 0.18),
            child: InkWell(
              borderRadius: BorderRadius.circular(LavelleRadius.md),
              onTap: onSearchTap,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.search_rounded, color: t.accent),
                    Expanded(
                      child: MainText(
                        context.l10n.search_laundries_hint,
                        fontSize: 14,
                        color: t.subText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(LavelleRadius.md),
          onTap: onMapTap,
          child: const GlassIcon(icon: Icons.map_outlined, size: 52),
        ),
      ],
    );
  }
}

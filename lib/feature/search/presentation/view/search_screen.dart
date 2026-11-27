import '../../../../shared/widgets/shared_widgets.dart';
import '../../../laundry/presentation/view/widgets/lundry_card.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../domain/search_repository.dart';
import '../cubit/search_cubit.dart';

/// شاشة البحث. تُفتح من الرئيسية:
///   Navigator.push(context, MaterialPageRoute(builder: (_) => const LaundrySearchScreen()));
class LaundrySearchScreen extends StatelessWidget {
  static const String routeName = '/laundry-search';

  const LaundrySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => SearchCubit(
        const MockSearchRepository(),
        const MockRecentSearchesStore(),
        currentLocation: () => ctx.read<LocationCubit>().state.selected,
      )..init(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setText(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _clear() {
    _controller.clear();
    context.read<SearchCubit>().clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LavelleHeroBackground(
              height: topInset + 120,
              showBubbles: false,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 0),
                child: _SearchHeader(
                  controller: _controller,
                  focusNode: _focus,
                  onChanged: cubit.onQueryChanged,
                  onSubmitted: cubit.submit,
                  onClear: _clear,
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) => _SearchBody(
                    state: state,
                    onPickRecent: (q) {
                      _setText(q);
                      cubit.submit(q);
                      _focus.unfocus();
                    },
                    onClearSearch: _clear,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// الهيدر: رجوع + حقل البحث
// ═════════════════════════════════════════════════════════════

class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Row(
      spacing: 10,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(LavelleRadius.md),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
        ),
        Expanded(
          child: Material(
            color: t.card,
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(LavelleRadius.md),
            child: Container(
              height: 52,
              padding: const EdgeInsetsDirectional.only(start: 14, end: 4),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: t.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: t.text,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: context.l10n.search_laundries_hint,
                        hintStyle: TextStyle(fontSize: 14, color: t.subText),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) return const SizedBox(width: 10);
                      return IconButton(
                        onPressed: onClear,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: t.subText,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
// المحتوى حسب الحالة
// ═════════════════════════════════════════════════════════════

class _SearchBody extends StatelessWidget {
  final SearchState state;
  final ValueChanged<String> onPickRecent;
  final VoidCallback onClearSearch;

  const _SearchBody({
    required this.state,
    required this.onPickRecent,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SearchCubit>();

    final Widget body;
    switch (state.phase) {
      case SearchPhase.idle:
        body = state.recent.isEmpty
            ? LavelleStateView(
                icon: Icons.search_rounded,
                title: l10n.search_idle_title,
                message: l10n.search_idle_message,
              )
            : _RecentList(
                items: state.recent,
                onPick: onPickRecent,
                onRemove: cubit.removeRecent,
                onClearAll: cubit.clearRecent,
              );
        break;

      case SearchPhase.loading:
        body = const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: LavelleSkeletonList(itemCount: 3),
        );
        break;

      case SearchPhase.results:
        body = ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          children: [
            LavelleSectionHeader(
              title: '${l10n.search_results_title} (${state.results.length})',
            ),
            const SizedBox(height: 14),
            for (final laundry in state.results)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LaundryCard(
                  laundry: laundry,
                  onTap: () {
                    cubit.remember(state.query);
                    // TODO(خطوة 4): افتح تفاصيل المغسلة laundry.id
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Step 4 · Laundry details — next step'),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
        break;

      case SearchPhase.empty:
        body = LavelleStateView(
          icon: Icons.search_off_rounded,
          title: l10n.no_search_results,
          message: l10n.no_search_results_message,
          actionLabel: l10n.clear_search,
          onAction: onClearSearch,
        );
        break;

      case SearchPhase.error:
        body = LavelleErrorView(onRetry: cubit.retry);
        break;

      case SearchPhase.noConnection:
        body = LavelleErrorView(onRetry: cubit.retry, isNoConnection: true);
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: KeyedSubtree(key: ValueKey<SearchPhase>(state.phase), child: body),
    );
  }
}

class _RecentList extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onPick;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const _RecentList({
    required this.items,
    required this.onPick,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final l10n = context.l10n;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      children: [
        LavelleSectionHeader(
          title: l10n.recent_searches,
          actionLabel: l10n.clear_all,
          onAction: onClearAll,
        ),
        const SizedBox(height: 8),
        for (final q in items)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onPick(q),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 20, color: t.subText),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MainText(
                      q,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: t.text,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onRemove(q),
                    icon: Icon(Icons.close_rounded, size: 18, color: t.subText),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

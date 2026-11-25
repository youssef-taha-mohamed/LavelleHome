import 'dart:developer';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../core/utils/styles_link.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../provider/provider.dart';
import 'widgets/cart_item_card.dart';
import '../widgets/clear_cart_dialog.dart';
import '../widgets/empty_cart.dart';
import '../summary/cart_summary_screen.dart';
import 'widgets/loading_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const String routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().getCartItems(isBackgroundRefresh: false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if (provider.state == CartProviderState.deleteSuccess) {
            provider.getCartItems(isBackgroundRefresh: true);
          }
          if (provider.state == CartProviderState.error &&
                  provider.errorMessage != null ||
              provider.state == CartProviderState.deleteError) {
            showCustomSnackBar(
              context,
              icon: Icons.error_outline_rounded,
              message: provider.errorMessage!,
              backgroundColor: MyColors.appRed,
            );
            provider.clearError();
          }

          if (provider.state == CartProviderState.success &&
              provider.successMessage != null) {
            showCustomSnackBar(
              context,
              icon: Icons.check_circle_rounded,
              message: provider.successMessage!,
              backgroundColor: Colors.green,
            );
            provider.clearSuccessMessage();
          }
        });

        if (provider.state == CartProviderState.stale) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.getCartItems();
          });
          return const LoadingCart();
        }

        if (provider.state == CartProviderState.loading) {
          return const LoadingCart();
        }

        final itemsList = provider.cartModel?.items ?? [];

        if (itemsList.isEmpty) {
          return const EmptyCart();
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return ModalProgressHUD(
              inAsyncCall: provider.state == CartProviderState.processing,
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<CartProvider>().getCartItems();
                },
                child: Scaffold(
                  body: SafeArea(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            CustomStudentHeader(
                              title: context.l10n.shopping_cart,
                              subTitle:
                                  '${itemsList.length} ${context.l10n.items_basket}',
                              showLeading: false,
                              showDelete: AuthenticationProvider
                                  .instance
                                  .currentUser
                                  ?.details
                                  .isAdult,
                              onDeleteTap: () {
                                HapticFeedback.lightImpact();
                                _showClearCartDialog(context, provider);
                              },
                            ),
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate((
                                        context,
                                        index,
                                      ) {
                                        return TweenAnimationBuilder<double>(
                                          duration: Duration(
                                            milliseconds: 400 + (index * 100),
                                          ),
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          builder: (context, value, child) {
                                            return Transform.translate(
                                              offset: Offset(
                                                30 * (1 - value),
                                                0,
                                              ),
                                              child: Opacity(
                                                opacity: value,
                                                child: CartItemCard(
                                                  item: itemsList[index],
                                                  onRemove: () {
                                                    HapticFeedback.lightImpact();
                                                    _showDeleteConfirmation(
                                                      context,
                                                      itemsList[index].planId,
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }, childCount: itemsList.length),
                                    ),
                                  ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: 100),
                                  ),
                                ],
                              ),
                            ),
                            if (AuthenticationProvider
                                    .instance
                                    .currentUser
                                    ?.details
                                    .isAdult !=
                                false)
                              _buildBottomActionBar(context, provider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomActionBar(BuildContext context, CartProvider provider) {
    final cartModel = provider.cartModel;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      context.l10n.total,
                      fontSize: 15,
                      color: context.isDark ? MyColors.white : MyColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        MainText.bigText(
                          cartModel?.total.toString() ?? '0',
                          fontSize: 28,
                          color: MyColors.primaryColor,
                        ),
                        MainText(
                          cartModel?.currency ?? '',
                          fontSize: 16,
                          color: MyColors.grey4,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: 18,
                        color: MyColors.primaryColor,
                      ),
                      MainText.bigText(
                        '${provider.totalSessionCount} ${context.l10n.a_class}',
                        fontSize: 14,
                        color: MyColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.ph,
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.95 + (0.05 * value),
                  child: MainButton(
                    title: context.l10n.checkout,
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        CartSummaryScreen.routeName,
                        arguments: provider.cartModel?.cartId ?? 0,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider provider) {
    final allPlanIds =
        provider.cartModel?.items.map((item) => item.planId).toList() ?? [];
    log('allPlanIds: $allPlanIds');
    showDialog(
      context: context,
      builder: (dialogContext) => DeleteConfirmationDialog(
        title: context.l10n.clear_shopping_cart,
        content: context.l10n.are_you_sure_clear_cart,
        icon: Icons.delete_sweep_rounded,
        confirmText: context.l10n.confirm,
        planIds: allPlanIds,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, num itemId) {
    showDialog(
      context: context,
      builder: (dialogContext) => DeleteConfirmationDialog(
        title: context.l10n.delete_item_from_cart,
        content: context.l10n.are_you_sure_delete_item_cart,
        icon: Icons.delete_outline_rounded,
        confirmText: context.l10n.delete,
        planIds: [itemId],
      ),
    );
  }
}

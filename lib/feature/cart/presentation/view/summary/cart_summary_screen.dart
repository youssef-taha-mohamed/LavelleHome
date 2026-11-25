import '../../../../../core/utils/styles_link.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../provider/provider.dart';
import '../../provider/summary_provider.dart';
import '../payment/payment_method_screen.dart';
import 'widgets/summary_card.dart';

class CartSummaryScreen extends StatelessWidget {
  const CartSummaryScreen({super.key, required this.cartId});

  final num cartId;

  static const routeName = '/cart-summary';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          SummaryProvider(repository: DependencyInjector.cartRepo),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _CartSummaryContent(cartId: cartId);
        },
      ),
    );
  }
}

class _CartSummaryContent extends StatefulWidget {
  final num cartId;

  const _CartSummaryContent({required this.cartId});

  @override
  State<_CartSummaryContent> createState() => _CartSummaryContentState();
}

class _CartSummaryContentState extends State<_CartSummaryContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late SummaryProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<SummaryProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getSummary(cartId: widget.cartId);
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              CustomStudentHeader(
                title: context.l10n.order_summary,
                subTitle:
                    '${context.watch<SummaryProvider>().summary?.items.length ?? 0} ${context.l10n.review_order_details}',
                icon: Icons.receipt_long_rounded,
                showLeading: true,
              ),
              Expanded(
                child: Consumer<SummaryProvider>(
                  builder: (context, provider, child) {
                    if (provider.state == SummaryProviderState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.state == SummaryProviderState.error) {
                      return Center(
                        child: Text(
                          provider.errorMessage ?? "Something went wrong",
                        ),
                      );
                    }
                   // final itemsList = provider.summary?.items ?? [];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                  spacing: 24,
                                  children: [
                                    SummaryCard(summary: provider.summary),
                                   // ItemsDetailsSummary(items: itemsList),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          context.watch<SummaryProvider>().state == SummaryProviderState.success
          ? _buildBottomPaymentButton(
              context,
              provider.summary?.orderNumber ?? "",
              provider.summary?.currencyCode ?? "",
              provider.summary?.totalPrice ?? 0,
            )
          : null,
    );
  }

  Widget _buildBottomPaymentButton(
    BuildContext context,
    String orderId,
    String currency,
    num amount,
  ) {
    final provider = context.watch<CartProvider>();
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(20),
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
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.95 + (0.05 * value),
              child: MainButton(
                title: context.l10n.pay_now,
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  await provider.getPaymentMethods();
                  if (provider.state ==
                          CartProviderState.paymentMethodsSuccess &&
                      context.mounted) {
                    Navigator.pushNamed(
                      context,
                      PaymentMethodScreen.routeName,
                      arguments: PaymentMethodScreenArgs(
                        orderId: orderId,
                        isRenewal: false,
                        amount: amount,
                        currency: currency,
                      ),
                    );
                  }
                },
                isLoading:
                    provider.state == CartProviderState.paymentMethodsLoading,
              ),
            );
          },
        ),
      ),
    );
  }
}

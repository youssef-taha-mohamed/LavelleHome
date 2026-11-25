import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../core/utils/styles_link.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../data/module/parameter/payment_parameter.dart';
import '../../../domain/entities/parameter/manual_payment.dart';
import '../../../domain/enum/payment_enum.dart';
import '../../provider/provider.dart';
import '../payment_view.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/security_notes.dart';
import 'widgets/manual_payment_section.dart';

class PaymentMethodScreenArgs {
  final String orderId;
  final bool isRenewal;
  final num amount;
  final String currency;

  PaymentMethodScreenArgs({
    required this.orderId,
    this.isRenewal = false,
    required this.amount,
    required this.currency,
  });
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.paymentArgs});

  final PaymentMethodScreenArgs paymentArgs;

  static const routeName = '/payment-method';

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with TickerProviderStateMixin {
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
    if (widget.paymentArgs.isRenewal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CartProvider>().getPaymentMethods();
        }
      });
    }
  }

  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.read<CartProvider>();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cartProvider.resetManualPayment(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<CartProvider>(
          builder: (context, provider, child) {
            if (!widget.paymentArgs.isRenewal &&
                (provider.cartModel?.items.isEmpty ?? true) &&
                provider.state != CartProviderState.processing &&
                provider.state != CartProviderState.loading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return ModalProgressHUD(
              inAsyncCall:
                  provider.state == CartProviderState.paymentLoading ||
                  provider.state == CartProviderState.manualPaymentLoading ||
                  provider.state == CartProviderState.processing,
              child: Scaffold(
                body: SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          StreamBuilder<User?>(
                            stream: AuthenticationProvider.instance
                                .userChanges(),
                            builder: (context, snapshot) {
                              final user = snapshot.data;
                              return CustomStudentHeader(
                                title: context.l10n.payment_method,
                                subTitle:
                                    context.l10n.choose_appropriate_method,
                                image:
                                    user?.details.image ??
                                    Constants.placeholderImage,
                                showLeading: true,
                                icon: Icons.payment_rounded,
                              );
                            },
                          ),
                          Expanded(
                            child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 16.0,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildPaymentAmountCard(
                                          widget.paymentArgs.amount,
                                          widget.paymentArgs.currency,
                                        ),
                                        24.ph,
                                        MainText(
                                          context.l10n.payment_method,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: context.isDark
                                              ? MyColors.white
                                              : MyColors.textDark,
                                        ),
                                        12.ph,
                                        MainText(
                                          context
                                              .l10n
                                              .choose_appropriate_method_continue,
                                          fontSize: 14,
                                          color: MyColors.grey4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        20.ph,
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final method =
                                                provider.payment[index];
                                            return PaymentMethodCard(
                                              method: method,
                                              icon: method == PaymentEnum.manual
                                                  ? Icons
                                                        .account_balance_rounded
                                                  : Icons.credit_card_rounded,
                                              color: MyColors.primaryColor,
                                              isSelected:
                                                  provider
                                                      .selectedPaymentMethod ==
                                                  method,
                                              onTap: () {
                                                provider.selectPaymentMethod(
                                                  method,
                                                );
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              16.ph,
                                          itemCount: provider.payment.length,
                                        ),
                                        if (provider.selectedPaymentMethod ==
                                            PaymentEnum.manual)
                                          const ManualPaymentSection(),
                                        24.ph,
                                        SecurityNotes(),
                                        80.ph,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomSheet: _buildBottomPaymentButton(context, provider),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentAmountCard(num amount, String currency) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyColors.darkGreen, MyColors.deepGreen],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: MyColors.darkGreen.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                MainText(
                  context.l10n.total_payment_amount,
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                12.ph,
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MainText(
                      amount.toString(),
                      fontSize: 42,
                      color: Colors.white,
                    ),
                    MainText(
                      currency,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPaymentButton(
    BuildContext context,
    CartProvider provider,
  ) {
    final isManual = provider.selectedPaymentMethod == PaymentEnum.manual;
    final isFileAttached = provider.attachedReceiptBytes != null;
    final isButtonEnabled =
        provider.selectedPaymentMethod != null && (!isManual || isFileAttached);
    final isProcessing = provider.state == CartProviderState.processing;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.95 + (0.05 * value),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: MyColors.primaryColor,
              ),
              child: MainButton(
                title: context.l10n.payment_confirmation,
                onPressed: isButtonEnabled && !isProcessing
                    ? () async {
                        HapticFeedback.heavyImpact();

                        if (isManual) {
                          await provider.putManualPayment(
                            parameters: ManualPaymentParameter(
                              orderNumber: widget.paymentArgs.orderId,
                              note: provider.noteController.text,
                              receiptFile: provider.attachedReceipt,
                              receiptBytes: provider.attachedReceiptBytes,
                              fileName: provider.attachedReceiptName,
                            ),
                          );

                          if (provider.state ==
                                  CartProviderState.manualPaymentSuccess &&
                              context.mounted) {
                            Fluttertoast.showToast(
                              msg:
                                  provider.successMessage ??
                                  'تم رفع الإيصال بنجاح. سيتم مراجعته قريباً.',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );

                            provider.resetManualPayment();

                            // Navigator.pushReplacementNamed(
                            //   context,
                            //   UserOrdersScreen.routeName,
                            //   arguments: OrderScreenParameter(
                            //     isPayment: true,
                            //     id: user?.role.id == UserRole.parent.id
                            //         ? child?.childId ?? ''
                            //         : user?.id ?? '',
                            //     fromParent: false,
                            //     childName: user?.role.id == UserRole.parent.id
                            //         ? child?.fullName ?? ''
                            //         : user?.fullName ?? '',
                            //     image: user?.role.id == UserRole.parent.id
                            //         ? child?.pictureUrl ?? ''
                            //         : user?.image ?? '',
                            //   ),
                            // );
                          } else if (provider.state ==
                                  CartProviderState.manualPaymentError &&
                              context.mounted) {
                            Fluttertoast.showToast(
                              msg:
                                  provider.errorMessage ??
                                  'فشل رفع الإيصال، يرجى المحاولة لاحقاً',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } else {
                          await provider.putPayment(
                            parameters: ExecutePaymentPara(
                              orderNumber: widget.paymentArgs.orderId,
                              paymentMethod:
                                  provider.selectedPaymentMethod != null
                                  ? provider.selectedPaymentMethod!.name
                                  : '',
                              studentId:
                                  AuthenticationProvider
                                      .instance
                                      .currentUser
                                      ?.details
                                      .id ??
                                  '',
                            ),
                          );

                          if (provider.state != CartProviderState.error &&
                              context.mounted) {
                            final paymentData = provider.paymentParameter;

                            if (paymentData != null) {
                              Navigator.of(context).pop();
                              await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentWebViewScreen(
                                    paymentData: paymentData,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('خطأ في تحضير بيانات الدفع'),
                                ),
                              );
                            }
                          }
                        }
                      }
                    : null,
                isLoading: isProcessing,
              ),
            ),
          );
        },
      ),
    );
  }
}

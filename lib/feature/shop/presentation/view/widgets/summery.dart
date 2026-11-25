import 'package:flutter/material.dart';

import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../shared/widgets/main_text.dart';

class CartSummaryWidget extends StatelessWidget {
  final int cartCount;
  final double totalPrice;
  final VoidCallback onCheckout;

  const CartSummaryWidget({
    super.key,
    required this.cartCount,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Divider
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MyColors.grey4.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              16.ph,

              // Cart Info and Checkout Button
              Row(
                children: [
                  // Cart Count and Total
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          'السلة',
                          fontSize: 12,
                          color: MyColors.grey4,
                          fontWeight: FontWeight.w500,
                        ),
                        6.ph,
                        Row(
                          children: [
                            MainText(
                              cartCount.toString(),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: MyColors.primaryColor,
                            ),
                            8.pw,
                            MainText(
                              'دورة',
                              fontSize: 14,
                              color: MyColors.grey4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  8.pw,
                  // Divider
                  Container(
                    width: 1,
                    height: 50,
                    color: MyColors.grey4.withValues(alpha: 0.2),
                  ),
                  8.pw,
                  // Total Price and Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MainText(
                          'الإجمالي',
                          fontSize: 12,
                          color: MyColors.grey4,
                          fontWeight: FontWeight.w500,
                        ),
                        6.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MainText(
                              'ر.س',
                              fontSize: 12,
                              color: MyColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                            4.pw,
                            MainText(
                              totalPrice.toStringAsFixed(0),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: MyColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              16.ph,

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onCheckout,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade500,
                            Colors.amber.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade400.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flash_on_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            8.pw,
                            MainText(
                              'إتمام الشراء',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
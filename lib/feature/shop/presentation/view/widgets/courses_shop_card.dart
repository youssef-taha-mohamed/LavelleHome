import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../cubit/shop_cubit.dart';

class CourseShopCard extends StatelessWidget {
  final CourseShop course;
  final bool isFavorite;
  final bool isInCart;
  final VoidCallback onFavoritePressed;
  final VoidCallback onAddToCart;

  const CourseShopCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.isInCart,
    required this.onFavoritePressed,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to course details
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image Area
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primaryColor.withValues(alpha: 0.1),
                        MyColors.lightTeal.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Course Icon
                      MainText(
                        course.image,
                        fontSize: 52,
                      ),

                      // Badge
                      if (course.badge != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade400,
                                  Colors.red.shade400,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: MainText(
                              course.badge!,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      // Favorite Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onFavoritePressed,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              size: 18,
                              color: isFavorite
                                  ? Colors.red
                                  : MyColors.grey4,
                            ),
                          ),
                        ),
                      ),

                      // Age Group
                      Positioned(
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: MainText(
                            course.ageGroup,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Course Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Course Name
                      MainText(
                        course.name,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: MyColors.textDark,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Rating and Students
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber,
                          ),
                          4.pw,
                          MainText(
                            course.rating.toString(),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: MyColors.textDark,
                          ),
                          4.pw,
                          MainText(
                            '(${(course.students / 1000).toStringAsFixed(1)}k)',
                            fontSize: 10,
                            color: MyColors.grey4,
                          ),
                        ],
                      ),

                      // Price and Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                '${course.price} ر.س',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryColor,
                              ),
                              MainText(
                                '${course.originalPrice} ر.س',
                                fontSize: 10,
                                color: MyColors.grey4,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: isInCart ? null : onAddToCart,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isInCart
                                    ? MyColors.primaryColor.withValues(alpha: 0.2)
                                    : MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isInCart
                                    ? Icons.check_rounded
                                    : Icons.shopping_cart_outlined,
                                size: 16,
                                color: isInCart
                                    ? MyColors.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
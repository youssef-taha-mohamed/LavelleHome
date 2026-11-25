import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../cubit/shop_cubit.dart';

class CategoryFilterWidget extends StatelessWidget {
  final List<ShopCategory> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilterWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            'التصنيفات',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColors.textDark,
          ),
          12.ph,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                categories.length,
                (index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category.id;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == categories.length - 1 ? 0 : 12,
                    ),
                    child: GestureDetector(
                      onTap: () => onCategorySelected(category.id),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.9 + (value * 0.1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          MyColors.primaryColor,
                                          MyColors.lightTeal,
                                        ],
                                      )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? MyColors.primaryColor
                                            .withValues(alpha: 0.3)
                                        : Colors.black.withValues(alpha: 0.05),
                                    blurRadius: isSelected ? 12 : 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MainText(
                                    category.icon,
                                    fontSize: 18,
                                  ),
                                  8.pw,
                                  MainText(
                                    category.name,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : MyColors.textDark,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

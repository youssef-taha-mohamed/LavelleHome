import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/main_text.dart';
import '../cubit/shop_cubit.dart';
import 'widgets/courses_shop_card.dart';
import 'widgets/filter.dart';
import 'widgets/header_widget.dart';
import 'widgets/summery.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  static const routeName = '/shop';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()..loadCourses(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF8FAFB),
                    Color(0xFFE8F4F8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: BlocBuilder<ShopCubit, ShopState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: ShopHeaderWidget(
                          cartCount:
                              state is ShopLoaded ? state.cart.length : 0,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: 24.ph,
                      ),
                      // Category Filter
                      SliverToBoxAdapter(
                        child: CategoryFilterWidget(
                          categories:
                              state is ShopLoaded ? state.categories : [],
                          selectedCategory: state is ShopLoaded
                              ? state.selectedCategory
                              : 'all',
                          onCategorySelected: (category) {
                            context.read<ShopCubit>().selectCategory(category);
                          },
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: 16.ph,
                      ),
                      // Courses Grid
                      if (state is ShopLoading)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                color: MyColors.primaryColor,
                              ),
                            ),
                          ),
                        )
                      else if (state is ShopError)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: MainText(
                                state.message,
                                fontSize: 16,
                                color: MyColors.customRed,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      else if (state is ShopLoaded)
                        state.filteredCourses.isEmpty
                            ? SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Column(
                                      children: [
                                        MainText(
                                          '🔍',
                                          fontSize: 48,
                                        ),
                                        16.ph,
                                        MainText(
                                          context.l10n.no_results,
                                          fontSize: 16,
                                          color: MyColors.grey4,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.7,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final course =
                                          state.filteredCourses[index];
                                      return CourseShopCard(
                                        course: course,
                                        isFavorite:
                                            state.favorites.contains(course.id),
                                        isInCart: state.cart.any(
                                            (item) => item.id == course.id),
                                        onFavoritePressed: () {
                                          context
                                              .read<ShopCubit>()
                                              .toggleFavorite(course.id);
                                        },
                                        onAddToCart: () {
                                          context
                                              .read<ShopCubit>()
                                              .addToCart(course);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: MainText(
                                                '${course.name} ${context.l10n.add_to_list}',
                                                color: Colors.white,
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor:
                                                  MyColors.primaryColor,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    childCount: state.filteredCourses.length,
                                  ),
                                ),
                              ),
                      SliverToBoxAdapter(
                        child: 32.ph,
                      ),
                    ],
                  );
                },
              ),
            ),

            // Cart Summary
            BlocBuilder<ShopCubit, ShopState>(
              builder: (context, state) {
                if (state is ShopLoaded && state.cart.isNotEmpty) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CartSummaryWidget(
                      cartCount: state.cart.length,
                      totalPrice: state.totalPrice,
                      onCheckout: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: MainText(
                              'Checkout Process Started',
                              color: Colors.white,
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

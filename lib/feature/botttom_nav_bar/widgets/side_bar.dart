import '../../../core/utils/styles_link.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../provider/nav_bar.dart';

class StudentSideBar extends StatefulWidget {
  const StudentSideBar({super.key});

  @override
  State<StudentSideBar> createState() => _StudentSideBarState();
}

class _StudentSideBarState extends State<StudentSideBar> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NavigationProvider>();
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final user = AuthenticationProvider.instance.currentUser?.details;
    final isCollapsed = provider.isSideBarCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: isCollapsed ? 76 : 250,
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkThemeBg : MyColors.white,
        border: Border(
          left: context.isArabic
              ? BorderSide(color: theme.primaryBorderColor, width: 1)
              : BorderSide.none,
          right: !context.isArabic
              ? BorderSide(color: theme.primaryBorderColor, width: 1)
              : BorderSide.none,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: isCollapsed ? 76 : 250,
          child: Column(
            children: [
              // ─── LOGO & TOGGLE BUTTON ──────────────────────────────────────────
              Container(
                padding: EdgeInsets.only(
                  top: 14,
                  bottom: 12,
                  left: isCollapsed ? 8 : 12,
                  right: isCollapsed ? 8 : 12,
                ),
                child: isCollapsed
                    ? Center(
                        child: Tooltip(
                          message: context.isArabic
                              ? 'توسيع القائمة'
                              : 'Expand Sidebar',
                          child: InkWell(
                            onTap: () => provider.toggleSideBar(),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(ImagesAssets.logo, height: 42),
                            ),
                          ),
                        ),
                      )
                    : Tooltip(
                        message: context.isArabic
                            ? 'تصغير القائمة'
                            : 'Collapse Sidebar',
                        child: InkWell(
                          onTap: () => provider.toggleSideBar(),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Image.asset(ImagesAssets.logo, height: 44),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: MainText(
                                    context.l10n.knoz,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: MyColors.primaryColor,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: context.isDark
                                        ? MyColors.white.withValues(alpha: 0.08)
                                        : MyColors.primaryColor.withValues(
                                            alpha: 0.08,
                                          ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: context.isDark
                                          ? MyColors.white.withValues(
                                              alpha: 0.12,
                                            )
                                          : MyColors.primaryColor.withValues(
                                              alpha: 0.15,
                                            ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    context.isArabic
                                        ? Icons
                                              .keyboard_double_arrow_right_rounded
                                        : Icons
                                              .keyboard_double_arrow_left_rounded,
                                    size: 16,
                                    color: context.isDark
                                        ? MyColors.white.withValues(alpha: 0.8)
                                        : MyColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              // ─── NAV ITEMS ─────────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCollapsed ? 8 : 14,
                    ),
                    child: Column(
                      spacing: 8,
                      children: [
                        _buildNavItem(
                          context: context,
                          index: 0,
                          label: context.l10n.home,
                          iconPath: SvgAssets.home,
                          isSvg: true,
                          provider: provider,
                          isCollapsed: isCollapsed,
                        ),
                        _buildNavItem(
                          context: context,
                          index: 1,
                          label: context.l10n.courses,
                          iconData: Icons.menu_book_rounded,
                          provider: provider,
                          isCollapsed: isCollapsed,
                        ),
                        _buildNavItem(
                          context: context,
                          index: 2,
                          label: context.l10n.my_courses,
                          iconPath: IconsAssets.categories,
                          isSvg: false,
                          provider: provider,
                          isCollapsed: isCollapsed,
                        ),
                        _buildNavItem(
                          context: context,
                          index: 3,
                          label: context.l10n.notification,
                          iconData: Icons.notifications_rounded,
                          provider: provider,
                          isCollapsed: isCollapsed,
                        ),
                        _buildNavItem(
                          context: context,
                          index: 4,
                          label: context.l10n.cart,
                          iconData: Icons.shopping_cart_rounded,
                          provider: provider,
                          isCollapsed: isCollapsed,
                        ),
                        _buildNavItem(
                          context: context,
                          index: 5,
                          label: context.l10n.more,
                          iconData: Icons.more_horiz_rounded,
                          provider: provider,
                          isCollapsed: isCollapsed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── USER PROFILE & SWITCH ROLE ─────────────────────────────────────────
              if (user != null)
                Padding(
                  padding: EdgeInsets.all(isCollapsed ? 8 : 14),
                  child: Column(
                    children: [
                      if (isCollapsed)
                        Tooltip(
                          message: user.fullName,
                          waitDuration: const Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: () => provider.changeIndex(5),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: theme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                border: theme.primaryBorder,
                                boxShadow: theme.mediumShadow,
                              ),
                              child: Center(
                                child: EnhancedNetworkImageWidget(
                                  imageUrl:
                                      user.image != null && user.image != ""
                                      ? user.image
                                      : Constants.placeholderImage,
                                  width: 36,
                                  height: 36,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MyColors.primaryColor,
                                    width: 2,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () => provider.changeIndex(5),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: theme.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                              border: theme.primaryBorder,
                              boxShadow: theme.mediumShadow,
                            ),
                            child: Row(
                              spacing: 8,
                              children: [
                                EnhancedNetworkImageWidget(
                                  imageUrl:
                                      user.image != null && user.image != ""
                                      ? user.image
                                      : Constants.placeholderImage,
                                  width: 44,
                                  height: 44,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MyColors.primaryColor,
                                    width: 2,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MainText(
                                        user.fullName,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: context.isDark
                                            ? MyColors.white
                                            : MyColors.textDark,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      MainText(
                                        context.l10n.student,
                                        fontSize: 12,
                                        color: MyColors.grey600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required NavigationProvider provider,
    required bool isCollapsed,
    String? iconPath,
    IconData? iconData,
    bool isSvg = false,
    GlobalKey? keyValue,
  }) {
    final bool isSelected = provider.currentIndex == index;
    final bool isHovered = hoveredIndex == index;
    final totalShowcases = AppResponsive.isDesktop(context) ? 11 : 9;

    return CustomShowcase(
      showcaseId: 'student_sidebar_item_$index',
      showcaseGroupId: 'unified_student_tour_v1',
      keyValue: keyValue ?? GlobalKey(),
      title: label,
      description: 'Explore $label section',
      totalShowcases: totalShowcases,
      currentIndex: index,
      child: Tooltip(
        message: isCollapsed ? label : '',
        waitDuration: const Duration(milliseconds: 300),
        child: MouseRegion(
          onEnter: (_) => setState(() => hoveredIndex = index),
          onExit: (_) => setState(() => hoveredIndex = null),
          child: GestureDetector(
            onTap: () => provider.changeIndex(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? MyColors.primaryColor.withValues(alpha: 0.1)
                    : isHovered
                    ? MyColors.grey100.withValues(
                        alpha: context.isDark ? 0.05 : 0.5,
                      )
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(
                        color: MyColors.primaryColor.withValues(alpha: 0.2),
                      )
                    : Border.all(color: Colors.transparent),
              ),
              child: isCollapsed
                  ? Center(
                      child: _buildIcon(
                        isSelected: isSelected,
                        isHovered: isHovered,
                        iconPath: iconPath,
                        iconData: iconData,
                        isSvg: isSvg,
                        context: context,
                      ),
                    )
                  : Row(
                      children: [
                        _buildIcon(
                          isSelected: isSelected,
                          isHovered: isHovered,
                          iconPath: iconPath,
                          iconData: iconData,
                          isSvg: isSvg,
                          context: context,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MainText(
                            label,
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? MyColors.primaryColor
                                : context.isDark
                                ? MyColors.white.withValues(alpha: 0.7)
                                : MyColors.textDark.withValues(alpha: 0.8),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon({
    required bool isSelected,
    required bool isHovered,
    required BuildContext context,
    String? iconPath,
    IconData? iconData,
    bool isSvg = false,
  }) {
    final Color color = isSelected
        ? MyColors.primaryColor
        : context.isDark
        ? MyColors.white.withValues(alpha: 0.6)
        : MyColors.black600;

    if (iconData != null) {
      return Icon(iconData, color: color, size: 24);
    }

    if (isSvg && iconPath != null) {
      return SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        height: 24,
        width: 24,
      );
    }

    if (iconPath != null) {
      return Image.asset(iconPath, color: color, height: 24, width: 24);
    }

    return const SizedBox(width: 24);
  }
}

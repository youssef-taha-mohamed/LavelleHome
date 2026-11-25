import '../../../../core/utils/styles_link.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../user/domain/entities/user_details.dart';
import '../cubit/student_profile_cubit.dart';
import 'profile_edit.dart';
import 'widgets/change_email_sheet.dart';

class ProfileViewTablet extends StatelessWidget {
  const ProfileViewTablet({
    super.key,
    required this.user,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  final UserDetails? user;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ─── Back Button ──────────────────────────────────────
                SliverToBoxAdapter(child: _TabletBackBar(colors: colors)),
                // ─── Hero Profile Banner ────────────────────────────
                SliverToBoxAdapter(child: _HeroProfileBanner(user: user)),
                // ─── Info Cards Grid ────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.getPadding(context) * 2,
                    vertical: AppResponsive.getPadding(context),
                  ),
                  sliver: SliverToBoxAdapter(child: _InfoCardsGrid(user: user)),
                ),
                // ─── Action Buttons ─────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.getPadding(context) * 2,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _TabletActionButtons(user: user),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Back Bar
// ═══════════════════════════════════════════════════════════════════════════
class _TabletBackBar extends StatelessWidget {
  const _TabletBackBar({required this.colors});

  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.getPadding(context) * 2,
        vertical: AppResponsive.getPadding(context),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.isDark
                    ? MyColors.darkItemBG3
                    : MyColors.neutral100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: AppResponsive.getIconSize(context, base: 20),
                color: colors.textColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          MainText(
            context.l10n.profile_settings,
            fontSize: AppResponsive.getFontSize(
              context,
              mobile: 18,
              smallTablet: 22,
              largeTablet: 24,
            ),
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Hero Profile Banner — full-width gradient with avatar + name + username
// ═══════════════════════════════════════════════════════════════════════════
class _HeroProfileBanner extends StatelessWidget {
  const _HeroProfileBanner({required this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.getPadding(context) * 2,
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.getPadding(context) * 1.5,
        horizontal: AppResponsive.getPadding(context) * 1.2,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyColors.primaryColor, MyColors.darkGreen],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryColor.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.islamicGold.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 80,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          // ─── Content Row ───────────────────────────────────────
          Row(
            children: [
              // Avatar
              _ProfileAvatar(user: user),
              const SizedBox(width: 36),
              // Name + Username + Role Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      user?.fullName ?? '',
                      fontSize: AppResponsive.getFontSize(
                        context,
                        mobile: 24,
                        smallTablet: 28,
                        largeTablet: 32,
                      ),
                      fontWeight: FontWeight.w800,
                      color: MyColors.white,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: MyColors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.alternate_email,
                            size: AppResponsive.getIconSize(context, base: 14),
                            color: MyColors.islamicGold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        MainText(
                          user?.username ?? '',
                          fontSize: AppResponsive.getFontSize(
                            context,
                            mobile: 16,
                            smallTablet: 18,
                            largeTablet: 24,
                          ),
                          color: MyColors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (user?.role.name != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.islamicGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: MyColors.islamicGold.withValues(alpha: 0.4),
                    ),
                  ),
                  child: MainText(
                    user?.role.name ?? '',
                    fontSize: AppResponsive.getFontSize(
                      context,
                      mobile: 14,
                      smallTablet: 16,
                      largeTablet: 18,
                    ),
                    fontWeight: FontWeight.w600,
                    color: MyColors.islamicGold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Profile Avatar with glow effect
// ═══════════════════════════════════════════════════════════════════════════
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppResponsive.getFontSize(
        context,
        mobile: 100,
        smallTablet: 110,
        largeTablet: 130,
      ),
      height: AppResponsive.getFontSize(
        context,
        mobile: 100,
        smallTablet: 110,
        largeTablet: 130,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // boxShadow: [
        //   BoxShadow(
        //     color: MyColors.islamicGold.withValues(alpha: 0.35),
        //     blurRadius: 25,
        //     spreadRadius: 3,
        //   ),
        // ],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MyColors.islamicGold,
              MyColors.islamicGold.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: MyColors.darkGreen,
          ),
          child: ClipOval(
            child: user?.image != null
                ? EnhancedNetworkImageWidget(
                    imageUrl: user?.image,
                    width: 122,
                    height: 122,
                    fit: BoxFit.cover,
                    placeHolderWidget: _defaultAvatar(),
                  )
                : _defaultAvatar(),
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 122,
      height: 122,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [MyColors.primaryColor, MyColors.darkGreen],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: MainText(
          user?.fullName.isNotEmpty == true
              ? user!.fullName.substring(0, 1).toUpperCase()
              : '?',
          color: MyColors.islamicGold,
          fontSize: 48,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Info Cards Grid — 2x3 grid of personal info cards
// ═══════════════════════════════════════════════════════════════════════════
class _InfoCardsGrid extends StatelessWidget {
  const _InfoCardsGrid({required this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final userType =
        AuthenticationProvider.instance.currentUser?.details.role.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: MyColors.primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            MainText(
              context.l10n.personal_information,
              fontSize: AppResponsive.getFontSize(
                context,
                mobile: 18,
                smallTablet: 22,
                largeTablet: 24,
              ),
              fontWeight: FontWeight.w700,
              color: colors.textColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Grid of info cards
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isLargeTablet =
                AppResponsive.getCategory(context) ==
                DeviceCategory.largeTablet;
            final cardWidth = isLargeTablet
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _InfoCard(
                    icon: Icons.email_rounded,
                    iconColor: MyColors.primaryColor,
                    label: context.l10n.email,
                    value: user?.email ?? 'example@email.com',
                    showEdit: userType != UserRole.parent.id,
                    onEdit: () => _showEditEmailSheet(context),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _InfoCard(
                    icon: Icons.phone_rounded,
                    iconColor: MyColors.islamicGold,
                    label: context.l10n.phone_number,
                    value: _getDisplayPhone(user),
                    valueTextDirection: TextDirection.ltr,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _InfoCard(
                    icon: Icons.location_on_rounded,
                    iconColor: MyColors.success500,
                    label: context.l10n.address,
                    value: user?.address ?? '.....',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _InfoCard(
                    icon: Icons.male,
                    iconColor: MyColors.lightTeal,
                    label: context.l10n.gender,
                    value: user?.gender?.name ?? '-',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _InfoCard(
                    icon: Icons.cake_rounded,
                    iconColor: MyColors.tertiaryColor,
                    label: context.l10n.birthday,
                    value: _formatDate(user?.birthday),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getDisplayPhone(UserDetails? user) {
    if (user == null) return '+20 123 456 7890';
    String phone = user.phone;
    final code = user.phoneNumberCode;

    if (code.isNotEmpty && !phone.startsWith(code) && !phone.startsWith('+')) {
      return '$code $phone';
    }
    return phone;
  }

  void _showEditEmailSheet(BuildContext context) {
    final studentProfileCubit = context.read<StudentProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: studentProfileCubit,
          child: const ChangeEmailSheet(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Individual Info Card
// ═══════════════════════════════════════════════════════════════════════════
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.showEdit = false,
    this.onEdit,
    this.valueTextDirection,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool showEdit;
  final VoidCallback? onEdit;
  final TextDirection? valueTextDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.smallShadow,
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: AppResponsive.getFontSize(
              context,
              mobile: 50,
              smallTablet: 55,
              largeTablet: 60,
            ),
            height: AppResponsive.getFontSize(
              context,
              mobile: 50,
              smallTablet: 55,
              largeTablet: 60,
            ),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 28)),
          ),
          const SizedBox(width: 16),
          // Label + value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  label,
                  fontSize: AppResponsive.getFontSize(
                    context,
                    mobile: 16,
                    smallTablet: 18,
                    largeTablet: 20,
                  ),
                  color: colors.subTextColor,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 4),
                MainText(
                  value,
                  fontSize: AppResponsive.getFontSize(
                    context,
                    mobile: 14,
                    smallTablet: 16,
                    largeTablet: 18,
                  ),
                  color: colors.textColor,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  textDirection: valueTextDirection,
                ),
              ],
            ),
          ),
          // Edit button
          if (showEdit && onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.edit, color: iconColor, size: 24),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Action Buttons Row
// ═══════════════════════════════════════════════════════════════════════════
class _TabletActionButtons extends StatelessWidget {
  const _TabletActionButtons({required this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    final bool isLargeTablet =
        AppResponsive.getCategory(context) == DeviceCategory.largeTablet;

    return Flex(
      direction: isLargeTablet ? Axis.horizontal : Axis.vertical,
      children: [
        if (isLargeTablet)
          Expanded(child: _editButton(context))
        else
          _editButton(context),
        SizedBox(width: isLargeTablet ? 16 : 0, height: isLargeTablet ? 0 : 16),
        if (isLargeTablet)
          Expanded(child: _myCoursesButton(context))
        else
          _myCoursesButton(context),
      ],
    );
  }

  Widget _editButton(BuildContext context) {
    return _GradientActionButton(
      icon: Icons.edit_rounded,
      title: context.l10n.edit_profile,
      gradient: const LinearGradient(
        colors: [MyColors.primaryColor, MyColors.darkGreen],
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, ProfileEdit.routeName);
      },
    );
  }

  Widget _myCoursesButton(BuildContext context) {
    return _GradientActionButton(
      icon: Icons.school_rounded,
      title: context.l10n.my_courses,
      gradient: LinearGradient(
        colors: [
          MyColors.islamicGold,
          MyColors.islamicGold.withValues(alpha: 0.75),
        ],
      ),
      onTap: () {
        HapticFeedback.lightImpact();
       // Navigator.pushNamed(context, MyCoursesView.routeName, arguments: true);
      },
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryColor.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: MyColors.white,
                  size: AppResponsive.getIconSize(context, base: 18),
                ),
                const SizedBox(width: 12),
                MainText(
                  title,
                  color: MyColors.white,
                  fontSize: AppResponsive.getFontSize(
                    context,
                    mobile: 18,
                    smallTablet: 22,
                    largeTablet: 24,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

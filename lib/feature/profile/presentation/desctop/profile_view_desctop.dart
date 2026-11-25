import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/utils/format_data.dart';
import '../../../../shared/screens/mobile/language/language_screen.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../auth/presentation/login/view/login.dart';
import '../../../setting/presentation/view/setting_view.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/domain/entities/user_details.dart';
import '../view/profile_edit.dart';

class StudentProfileDesktop extends StatefulWidget {
  const StudentProfileDesktop({super.key});

  @override
  State<StudentProfileDesktop> createState() => _StudentProfileDesktopState();
}

class _StudentProfileDesktopState extends State<StudentProfileDesktop> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? MyColors.darkThemeBg : const Color(0xFFF8F9FA),
      body: StreamBuilder<User?>(
        stream: AuthenticationProvider.instance.userChanges(),
        builder: (context, snapshot) {
          final userDetails = snapshot.data?.details;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isCompact = constraints.maxWidth < 1100;
                    return isCompact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileHero(context, userDetails),
                              const SizedBox(height: 32),
                              _buildPersonalDetails(context, userDetails),
                              const SizedBox(height: 32),
                              _buildSettingsGrid(context),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: _buildProfileHero(context, userDetails),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildPersonalDetails(context, userDetails),
                                    const SizedBox(height: 32),
                                    _buildSettingsGrid(context),
                                  ],
                                ),
                              ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 64),
                Center(child: _buildFooter(context, _packageInfo.version)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHero(BuildContext context, UserDetails? user) {
    final bool isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? MyColors.darkItemBG2 : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          EnhancedNetworkImageWidget(
            imageUrl: user?.image != null && user?.image != ""
                ? user!.image
                : Constants.placeholderImage,
            width: 160,
            height: 160,
            shape: BoxShape.circle,
            border: Border.all(color: MyColors.primaryColor, width: 2),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 32),
          MainText(
            user?.fullName ?? "",
            fontSize: 28,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          MainButton(
            onPressed: () =>
                Navigator.pushNamed(context, ProfileEdit.routeName),
            backgroundColor: MyColors.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit_note_rounded, color: Colors.white),
                const SizedBox(width: 12),
                MainText(
                  context.l10n.edit_profile,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayPhone(UserDetails? user) {
    if (user == null) return '-';
    String phone = user.phone;
    final code = user.phoneNumberCode;

    if (code.isNotEmpty && !phone.startsWith(code) && !phone.startsWith('+')) {
      return '$code $phone';
    }
    return phone;
  }

  Widget _buildPersonalDetails(BuildContext context, UserDetails? user) {
    return _buildWebSectionCard(
      context,
      title: context.l10n.personal_information,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        children: [
          _buildInfoTile(
            context,
            icon: Icons.mail_outline_rounded,
            label: context.l10n.email,
            value: user?.email ?? "-",
            color: Colors.blue,
          ),
          _buildInfoTile(
            context,
            icon: Icons.phone_android_rounded,
            label: context.l10n.phone_number,
            value: _getDisplayPhone(user),
            color: Colors.green,
            valueTextDirection: TextDirection.ltr,
          ),
          _buildInfoTile(
            context,
            icon: Icons.cake_outlined,
            label: context.l10n.birthday,
            value: DateFormatter.formatCustom(
              user?.birthday ?? DateTime.now(),
              'dd MMMM yyyy',
            ),
            color: Colors.orange,
          ),
          _buildInfoTile(
            context,
            icon: Icons.location_on_outlined,
            label: context.l10n.address_information,
            value: user?.address ?? "-",
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGrid(BuildContext context) {
    return _buildWebSectionCard(
      context,
      title: context.l10n.settings,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.4,
        children: [
          _buildSettingsBox(
            context,
            icon: Icons.assignment_outlined,
            title: context.l10n.my_assessment,
            onTap: () {
              
            },
            color: MyColors.primaryColor,
          ),
          _buildSettingsBox(
            context,
            icon: Icons.receipt_long_outlined,
            title: context.l10n.order_history,
            onTap: () {
              
            },
            color: const Color(0xFFE68A36),
          ),
          _buildSettingsBox(
            context,
            icon: Icons.settings_suggest_outlined,
            title: context.l10n.app_settings,
            onTap: () => Navigator.pushNamed(context, SettingView.routeName),
            color: const Color(0xFF4B9F4B),
          ),
          _buildSettingsBox(
            context,
            icon: Icons.translate_rounded,
            title: context.l10n.app_language,
            onTap: () => Navigator.pushNamed(context, LanguageScreen.routeName),
            color: Colors.purple,
          ),
          _buildSettingsBox(
            context,
            icon: Icons.logout_rounded,
            title: context.l10n.logout,
            onTap: () async {
              AuthenticationProvider.instance.logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
            },
            color: Colors.red,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWebSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final bool isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? MyColors.darkItemBG2 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              MainText(title, fontSize: 22, fontWeight: FontWeight.w800),
            ],
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    TextDirection? valueTextDirection,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainText(
                  label.toUpperCase(),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                  letterSpacing: 1.1,
                ),
                const SizedBox(height: 4),
                MainText(
                  value,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: valueTextDirection,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.isDark
              ? MyColors.darkItemBG3
              : const Color(0xFFF1F4F4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDestructive ? Colors.red : color).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            MainText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              color: isDestructive ? Colors.red : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String version) {
    return Column(
      spacing: 4,
      children: [
        MainText(
          context.l10n.konoz,
          fontSize: 12,
          color: MyColors.neutral500,
          fontWeight: FontWeight.w600,
        ),
        MainText(
          context.l10n.version(version),
          fontSize: 10,
          color: MyColors.neutral400,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

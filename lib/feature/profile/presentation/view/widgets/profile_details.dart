import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../core/utils/format_data.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/enum/user_role.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../user/domain/entities/user_details.dart';
import '../../cubit/student_profile_cubit.dart';
import 'change_email_sheet.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key, this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final userType =
        AuthenticationProvider.instance.currentUser?.details.role.id;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            spacing: 12,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: MyColors.primaryColor,
                  size: 20,
                ),
              ),
              MainText.bigText(
                context.l10n.personal_information,
                color: MyColors.primaryColor,
              ),
            ],
          ),
          16.ph,
          // Profile Details
          _buildDetailRow(
            icon: Icons.email_rounded,
            label: context.l10n.email,
            value: user?.email ?? 'example@email.com',
            color: MyColors.primaryColor,
            isEmail: userType == UserRole.parent.id ? false : true,
            context: context,
          ),
          _buildDetailRow(
            icon: Icons.phone_rounded,
            label: context.l10n.phone_number,
            value: _getDisplayPhone(user),
            color: MyColors.islamicGold,
            valueTextDirection: TextDirection.ltr,
            context: context,
          ),
          _buildDetailRow(
            icon: Icons.location_on_rounded,
            label: context.l10n.address,
            value: user?.address ?? '.....',
            color: MyColors.green,
            context: context,
          ),
          _buildDetailRow(
            icon: Icons.male,
            label: context.l10n.gender,
            value: user?.gender?.name ?? 'ذكر',
            color: MyColors.green,
            context: context,
          ),
          _buildDetailRow(
            icon: Icons.cake_rounded,
            label: context.l10n.birthday,
            value: DateFormatter.formatDate(user?.birthday ?? DateTime(2025)),
            color: MyColors.tertiaryColor,
            isLast: true,
            context: context,
          ),
        ],
      ),
    );
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isLast = false,
    bool isEmail = false,
    TextDirection? valueTextDirection,
    required BuildContext context,
  }) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return Container(
      //color: colors.containerBackground,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      padding: EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Row(
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  label,
                  fontSize: 12,
                  color: colors.textColor,
                  fontWeight: FontWeight.w500,
                ),
                MainText(
                  value,
                  fontSize: 15,
                  color: colors.subTextColor,
                  fontWeight: FontWeight.w600,
                  textDirection: valueTextDirection,
                ),
              ],
            ),
          ),
          if (isEmail)
            GestureDetector(
              onTap: () {
                showEditEmailBottomSheet(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit, color: color, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  void showEditEmailBottomSheet(BuildContext context) {
    final studentProfileCubit = context.read<StudentProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: studentProfileCubit,
          child: ChangeEmailSheet(),
        );
      },
    );
  }
}

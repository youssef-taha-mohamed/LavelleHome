import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.editProfile,
    required this.myCourses,
  });

  final VoidCallback editProfile;
  final VoidCallback myCourses;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: _buildActionButton(
                title: context.l10n.edit_profile,
                icon: Icons.edit_rounded,
                gradient: LinearGradient(
                  colors: [
                    MyColors.primaryColor,
                    MyColors.primaryColor.shade700,
                  ],
                ),
                onTap: editProfile,
              ),
            ),
            Expanded(
              child: _buildActionButton(
                title: context.l10n.my_courses,
                icon: Icons.school_rounded,
                gradient: LinearGradient(
                  colors: [
                    MyColors.islamicGold,
                    MyColors.islamicGold.withValues(alpha: 0.7),
                  ],
                ),
                onTap: myCourses,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            MainText(
              title,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

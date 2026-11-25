import 'package:flutter/material.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../../shared/widgets/custom_header.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/redo_back.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  int? _expandedIndex;

  List<PolicySection> _getSections() {
    return [
      PolicySection(
        icon: Icons.info_outline,
        title: context.l10n.introduction,
        content: context.l10n.introduction_text,
      ),
      PolicySection(
        icon: Icons.description_outlined,
        title: context.l10n.info_we_collect,
        content: context.l10n.info_we_collect_text,
      ),
      PolicySection(
        icon: Icons.settings_outlined,
        title: context.l10n.how_we_use,
        content: context.l10n.how_we_use_text,
      ),
      PolicySection(
        icon: Icons.security_outlined,
        title: context.l10n.data_security,
        content: context.l10n.data_security_text,
      ),
      PolicySection(
        icon: Icons.verified_user_outlined,
        title: context.l10n.your_rights,
        content: context.l10n.your_rights_text,
      ),
      PolicySection(
        icon: Icons.contact_support_outlined,
        title: context.l10n.contact_privacy,
        content: context.l10n.contact_privacy_text,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sections = _getSections();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomStudentHeader(
              title: context.l10n.privacy_policy,
              subTitle: context.l10n.last_updated,
              showLeading: false,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Effective Date Card
                  _buildEffectiveDateCard(),
                  20.ph,
                  ...List.generate(
                    sections.length,
                    (index) {
                      return _buildPolicySection(
                        section: sections[index],
                        index: index,
                        isExpanded: _expandedIndex == index,
                        onTap: () {
                          setState(
                            () {
                              _expandedIndex =
                                  _expandedIndex == index ? null : index;
                            },
                          );
                        },
                      );
                    },
                  ),
                  40.ph,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectiveDateCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors.primaryColor.withValues(alpha: 0.1),
                MyColors.lightTeal.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: MyColors.primaryColor,
                  size: 20,
                ),
              ),
              14.pw,
              Expanded(
                child: MainText(
                  context.l10n.effective_date,
                  fontSize: 13,
                  color: context.isDark ? Colors.white70 : MyColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 8,
          top: 2,
          child: RedoBack(
            borderColor: MyColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicySection({
    required PolicySection section,
    required int index,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      section.icon,
                      color: MyColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  14.pw,
                  Expanded(
                    child: MainText.bigText(
                      section.title,
                      fontSize: 15,
                      color: context.isDark ? Colors.white : MyColors.textDark,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.isDark ? Colors.white60 : MyColors.grey4,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: context.isDark
                        ? const Color(0xFF252525)
                        : const Color(0xFFF0F0F0),
                  ),
                  MainText(
                    section.content,
                    fontSize: 13.5,
                    color: context.isDark ? Colors.white70 : MyColors.grey4,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class PolicySection {
  final IconData icon;
  final String title;
  final String content;

  PolicySection({
    required this.icon,
    required this.title,
    required this.content,
  });
}

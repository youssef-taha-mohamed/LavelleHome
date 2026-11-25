import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../widgets/main_text.dart';

class LanguageCardDesktop extends StatefulWidget {
  final dynamic language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCardDesktop({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<LanguageCardDesktop> createState() => LanguageCardDesktopState();
}

class LanguageCardDesktopState extends State<LanguageCardDesktop> {
  bool _isHovered = false;

  String _getFlagUrl(String code) {
    switch (code.toLowerCase()) {
      case 'ar':
        return 'https://flagcdn.com/w80/eg.png';
      case 'en':
        return 'https://flagcdn.com/w80/gb.png';
      case 'fr':
        return 'https://flagcdn.com/w80/fr.png';
      default:
        return 'https://flagcdn.com/w80/${code.toLowerCase()}.png';
    }
  }

  String _getSecondaryName(String code) {
    switch (code.toLowerCase()) {
      case 'ar':
        return 'Arabic';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final code = (widget.language.code as String? ?? '').toLowerCase();
    final name = widget.language.name as String? ?? '';
    final secondaryName = _getSecondaryName(code);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? (isDark
                    ? MyColors.primaryColor.withValues(alpha: 0.16)
                    : MyColors.primaryColor.withValues(alpha: 0.06))
                : (_isHovered
                    ? (isDark ? MyColors.darkItemBG4 : Colors.white)
                    : (isDark ? MyColors.darkItemBG3 : Colors.white.withValues(alpha: 0.9))),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? MyColors.primaryColor
                  : (_isHovered
                      ? MyColors.primaryColor.withValues(alpha: 0.4)
                      : (isDark ? Colors.white.withValues(alpha: 0.08) : MyColors.neutral200)),
              width: widget.isSelected ? 2 : 1.2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: MyColors.primaryColor.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : (_isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]),
          ),
          child: Row(
            children: [
              // Sleek flag image container
              Container(
                width: 52,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.white24 : Colors.black12,
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.2),
                  child: CachedNetworkImage(
                    imageUrl: _getFlagUrl(code),
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      color: isDark ? Colors.white10 : Colors.black12,
                    ),
                    errorWidget: (_, _, _) => const Icon(
                      Icons.flag_rounded,
                      size: 20,
                      color: MyColors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),

              // Language Names & Code Tag
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MainText(
                          name,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: widget.isSelected
                              ? (isDark ? Colors.white : MyColors.primaryColor)
                              : (isDark ? MyColors.white : MyColors.black900),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? MyColors.primaryColor.withValues(alpha: 0.15)
                                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: MainText(
                            code.toUpperCase(),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.isSelected
                                ? MyColors.primaryColor
                                : (isDark ? Colors.white60 : MyColors.grey),
                          ),
                        ),
                      ],
                    ),
                    if (secondaryName.isNotEmpty && secondaryName != name) ...[
                      const SizedBox(height: 3),
                      MainText(
                        secondaryName,
                        fontSize: 13,
                        color: widget.isSelected
                            ? (isDark ? Colors.white70 : MyColors.neutral700)
                            : MyColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ],
                ),
              ),

              // Selected indicator / Check badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? MyColors.primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? MyColors.primaryColor
                        : (isDark ? Colors.white30 : MyColors.neutral300),
                    width: widget.isSelected ? 2 : 1.5,
                  ),
                ),
                child: widget.isSelected
                    ? const Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

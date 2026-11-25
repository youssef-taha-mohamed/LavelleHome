import 'package:flutter/material.dart';
import '../../core/style/app_colors.dart';
import 'main_text.dart';

class CustomInfoWidget extends StatelessWidget {
  const CustomInfoWidget({
    super.key,
    required this.description,
    this.isTablet = false,
  });

  final String description;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.success100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.success300,
          width: 1,
        ),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(
            Icons.info_outline,
            color: MyColors.success700,
            size: isTablet ? 36 : 24,
          ),
          Expanded(
            child: MainText(
              description,
              fontSize: isTablet ? 20 : 12,
              maxLines: 4,
              color: MyColors.success700,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/custom_network_image.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../provider/update_profile.dart';

class ImageUpdateWidget extends StatelessWidget {
  const ImageUpdateWidget({super.key, required this.provider});

  final UpdateProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            spacing: 16,
            children: [
              // Profile Picture
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.primaryColor,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: _buildImagePreview(),
                      ),
                    ),
                    // Edit Picture Button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => provider.changeProfilePicture(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                MyColors.primaryColor,
                                MyColors.primaryColor.shade700,
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MainText(
                context.l10n.change_profile_image,
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    final xFile = provider.form.imageFile;

    if (xFile != null) {
      if (kIsWeb) {
        // Web: read bytes asynchronously
        return FutureBuilder<Uint8List>(
          future: xFile.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ClipOval(
                child: Image.memory(
                  snapshot.data!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildDefaultAvatar(),
                ),
              );
            }
            return _buildDefaultAvatar();
          },
        );
      } else {
        // Mobile: use File path directly
        return ClipOval(
          child: Image.file(
            File(xFile.path),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildDefaultAvatar(),
          ),
        );
      }
    }
    return EnhancedNetworkImageWidget(
      imageUrl: provider.form.imageUrl,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      fallbackWidget: _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryColor.withValues(alpha: 0.8),
            MyColors.primaryColor,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person_rounded, size: 60, color: Colors.white),
    );
  }
}

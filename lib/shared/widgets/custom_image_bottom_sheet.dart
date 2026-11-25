import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import '../../core/utils/image_crop.dart';
import '../../l10n/l10n.dart';
import 'custom_toast.dart';
import 'main_text.dart';

class ImageBottomSheet extends StatelessWidget {
  const ImageBottomSheet._({
    this.enableCrop = true,
    this.cropStyle,
    this.aspectRatio,
    this.lockAspectRatio = true,
  });

  final bool enableCrop;
  final CropStyle? cropStyle;
  final CropAspectRatio? aspectRatio;
  final bool lockAspectRatio;

  /// Shows image picker bottom sheet (Mobile only).
  ///
  /// Returns an [XFile] of the selected (and optionally cropped) image,
  /// or null if the user cancelled.
  static Future<XFile?> show(
    BuildContext context, {
    bool enableCrop = true,
    CropStyle? cropStyle,
    CropAspectRatio? aspectRatio,
    bool lockAspectRatio = true,
  }) {
    return showModalBottomSheet<XFile>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ImageBottomSheet._(
        enableCrop: enableCrop,
        cropStyle: cropStyle,
        aspectRatio: aspectRatio,
        lockAspectRatio: lockAspectRatio,
      ),
    );
  }

  /// Opens a file picker directly (Web only).
  ///
  /// Returns an [XFile] of the selected image, or null if cancelled.
  static Future<XFile?> showForWeb(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      return pickedFile;
    } catch (e) {
      if (context.mounted) {
        ToastService.showError(context, e.toString());
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          16.ph,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          16.ph,
          MainText(
            context.l10n.choose_photo,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          20.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.camera),
                    onPressed: () => _getImage(context, ImageSource.camera),
                    label: MainText(context.l10n.camera),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.image),
                    onPressed: () => _getImage(context, ImageSource.gallery),
                    label: MainText(context.l10n.gallery),
                  ),
                ),
              ],
            ),
          ),
          16.ph,
        ],
      ),
    );
  }

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      XFile resultFile = pickedFile;

      // Crop the image if enabled (mobile only — image_cropper doesn't support web)
      if (enableCrop && context.mounted) {
        final croppedFile = await ImageCropHelper.cropFromPath(
          context,
          path: pickedFile.path,
          cropStyle: cropStyle ?? CropStyle.circle,
          aspectRatio: aspectRatio ?? ImageCropHelper.ratioSquare,
          lockAspectRatio: lockAspectRatio,
          toolbarColor: MyColors.primaryColor,
        );

        if (croppedFile == null) return; // User cancelled crop
        resultFile = XFile(croppedFile.path);
      }

      if (context.mounted) {
        Navigator.pop(context, resultFile);
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showError(context, e.toString());
      }
    }
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Professional, reusable image crop helper.
///
/// Usage:
/// ```dart
/// // Pick + Crop in one step
/// final file = await ImageCropHelper.pickAndCrop(
///   context,
///   source: ImageSource.gallery,
///   cropShape: CropShape.circle,
/// );
///
/// // Crop an existing file
/// final cropped = await ImageCropHelper.crop(
///   context,
///   imageFile: existingFile,
/// );
/// ```
class ImageCropHelper {
  ImageCropHelper._();

  // ─── Configuration Defaults ──────────────────────────────────

  static const int _defaultMaxWidth = 1024;
  static const int _defaultMaxHeight = 1024;
  static const int _defaultCompressQuality = 85;
  static const CropStyle _defaultCropShape = CropStyle.circle;
  static const CropAspectRatio _defaultAspectRatio = CropAspectRatio(
    ratioX: 1,
    ratioY: 1,
  );

  // ─── Preset Aspect Ratios ────────────────────────────────────

  static const CropAspectRatio ratioSquare = CropAspectRatio(
    ratioX: 1,
    ratioY: 1,
  );
  static const CropAspectRatio ratio4x3 = CropAspectRatio(ratioX: 4, ratioY: 3);
  static const CropAspectRatio ratio16x9 = CropAspectRatio(
    ratioX: 16,
    ratioY: 9,
  );
  static const CropAspectRatio ratio3x4 = CropAspectRatio(ratioX: 3, ratioY: 4);

  // ─── Core: Crop an existing image file ───────────────────────

  /// Opens the crop screen for the given [imageFile].
  ///
  /// Returns the cropped [File] or `null` if the user cancelled.
  ///
  /// Parameters:
  /// - [cropStyle]: Circle or Rectangle (default: circle)
  /// - [aspectRatio]: Lock aspect ratio (default: 1:1)
  /// - [lockAspectRatio]: Whether to lock the ratio (default: true)
  /// - [maxWidth] / [maxHeight]: Max output dimensions (default: 1024)
  /// - [compressQuality]: JPEG quality 0-100 (default: 85)
  /// - [toolbarTitle]: Title shown in crop toolbar
  /// - [toolbarColor]: Toolbar background color
  /// - [toolbarWidgetColor]: Toolbar icons & text color
  /// - [activeControlsWidgetColor]: Active crop controls color
  static Future<File?> crop(
    BuildContext context, {
    required File imageFile,
    CropStyle? cropStyle,
    CropAspectRatio? aspectRatio,
    bool lockAspectRatio = true,
    int? maxWidth,
    int? maxHeight,
    int? compressQuality,
    String? toolbarTitle,
    Color? toolbarColor,
    Color? toolbarWidgetColor,
    Color? activeControlsWidgetColor,
    List<CropAspectRatioPreset>? aspectRatioPresets,
  }) async {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      maxWidth: maxWidth ?? _defaultMaxWidth,
      maxHeight: maxHeight ?? _defaultMaxHeight,
      compressQuality: compressQuality ?? _defaultCompressQuality,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: aspectRatio ?? _defaultAspectRatio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: toolbarTitle ?? 'Crop Image',
          toolbarColor: toolbarColor ?? primaryColor,
          toolbarWidgetColor: toolbarWidgetColor ?? Colors.white,
          activeControlsWidgetColor: activeControlsWidgetColor ?? primaryColor,
          backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          cropStyle: cropStyle ?? _defaultCropShape,
          lockAspectRatio: lockAspectRatio,
          hideBottomControls: false,
          initAspectRatio: CropAspectRatioPreset.square,
          aspectRatioPresets:
              aspectRatioPresets ??
              [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.original,
              ],
        ),
        IOSUiSettings(
          title: toolbarTitle ?? 'Crop Image',
          cancelButtonTitle: 'Cancel',
          doneButtonTitle: 'Done',
          cropStyle: cropStyle ?? _defaultCropShape,
          aspectRatioLockEnabled: lockAspectRatio,
          resetAspectRatioEnabled: !lockAspectRatio,
          aspectRatioPickerButtonHidden: lockAspectRatio,
          aspectRatioPresets:
              aspectRatioPresets ??
              [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.original,
              ],
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  // ─── Convenience: Crop from path string (mobile only) ────────

  /// Crops an image from a file path string.
  /// Safe to call only on mobile (not web).
  /// Returns `null` on web or if the user cancelled.
  static Future<File?> cropFromPath(
    BuildContext context, {
    required String path,
    CropStyle? cropStyle,
    CropAspectRatio? aspectRatio,
    bool lockAspectRatio = true,
    int? maxWidth,
    int? maxHeight,
    int? compressQuality,
    String? toolbarTitle,
    Color? toolbarColor,
    Color? toolbarWidgetColor,
    Color? activeControlsWidgetColor,
    List<CropAspectRatioPreset>? aspectRatioPresets,
  }) {
    if (kIsWeb) return Future.value(null);
    return crop(
      context,
      imageFile: File(path),
      cropStyle: cropStyle,
      aspectRatio: aspectRatio,
      lockAspectRatio: lockAspectRatio,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      compressQuality: compressQuality,
      toolbarTitle: toolbarTitle,
      toolbarColor: toolbarColor,
      toolbarWidgetColor: toolbarWidgetColor,
      activeControlsWidgetColor: activeControlsWidgetColor,
      aspectRatioPresets: aspectRatioPresets,
    );
  }

  // ─── Convenience: Pick image then crop ───────────────────────

  /// Picks an image from [source] then opens the crop screen.
  ///
  /// Returns the cropped [File] or `null` if the user cancelled
  /// at any step (picker or cropper).
  static Future<File?> pickAndCrop(
    BuildContext context, {
    required ImageSource source,
    CropStyle? cropStyle,
    CropAspectRatio? aspectRatio,
    bool lockAspectRatio = true,
    int? maxWidth,
    int? maxHeight,
    int? compressQuality,
    String? toolbarTitle,
    Color? toolbarColor,
    Color? toolbarWidgetColor,
    Color? activeControlsWidgetColor,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    int? imageQuality,
  }) async {
    // Step 1: Pick the image
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: imageQuality ?? 90,
    );

    if (pickedFile == null) return null;

    if (!context.mounted) return null;

    // Step 2: Crop the picked image
    return crop(
      context,
      imageFile: File(pickedFile.path),
      cropStyle: cropStyle,
      aspectRatio: aspectRatio,
      lockAspectRatio: lockAspectRatio,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      compressQuality: compressQuality,
      toolbarTitle: toolbarTitle,
      toolbarColor: toolbarColor,
      toolbarWidgetColor: toolbarWidgetColor,
      activeControlsWidgetColor: activeControlsWidgetColor,
      aspectRatioPresets: aspectRatioPresets,
    );
  }

  // ─── Profile-specific convenience ────────────────────────────

  /// Shortcut for profile pictures: circular crop, 1:1 ratio, locked.
  static Future<File?> pickAndCropProfileImage(
    BuildContext context, {
    required ImageSource source,
    Color? toolbarColor,
  }) {
    return pickAndCrop(
      context,
      source: source,
      cropStyle: CropStyle.circle,
      aspectRatio: ratioSquare,
      lockAspectRatio: true,
      maxWidth: 512,
      maxHeight: 512,
      compressQuality: 90,
      toolbarTitle: 'Profile Photo',
      toolbarColor: toolbarColor,
    );
  }
}

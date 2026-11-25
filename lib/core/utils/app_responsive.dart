import 'package:flutter/material.dart';

import '../extension/extension_helper.dart';

enum DeviceCategory {
  smallMobile,
  mobile,
  smallTablet,
  largeTablet,
  desktop,
}

class AppResponsive {
  static DeviceCategory getCategory(BuildContext context) {
    double width = context.width;
    double height = context.height;

    // 1. Desktop (New breakpoint)
    if (width >= 1100) return DeviceCategory.desktop;

    // 2. Mobile (Legacy 600 breakpoint maintained for consistency)
    if (width < 360) return DeviceCategory.smallMobile;
    if (width < 650) return DeviceCategory.mobile;

    // 3. Tablet Categorization (Smart logic)
    // Large Tablet: Sufficient capacity in both dimensions (e.g. iPad Pro, iPad Mini Landscape)
    if (width >= 1000 && height >= 700) {
      return DeviceCategory.largeTablet;
    }

    // Small Tablet: Standard tablet space (e.g. iPad Mini Portrait, iPad Pro 11 Portrait)
    return DeviceCategory.smallTablet;
  }

  /// Returns a responsive font size based on current device category.
  static double getFontSize(BuildContext context,
      {required double mobile,
      double? smallMobile,
      double? smallTablet,
      double? largeTablet,
      double? desktop}) {
    final category = getCategory(context);
    switch (category) {
      case DeviceCategory.smallMobile:
        return smallMobile ?? (mobile * 0.8);
      case DeviceCategory.mobile:
        return mobile;
      case DeviceCategory.smallTablet:
        return smallTablet ?? (mobile * 1); // Reduced from 1.3
      case DeviceCategory.largeTablet:
        return largeTablet ?? (mobile * 1); // Default scale
      case DeviceCategory.desktop:
        return desktop ?? (mobile * 1.1); // Desktop scale
    }
  }

  /// Adjusts font weight based on language (English often looks bolder than Arabic).
  static FontWeight getFontWeight(BuildContext context, FontWeight weight) {
    if (context.isArabic) return weight;

    // For English/LTR, reduce boldness slightly if it's very bold
    if (weight == FontWeight.bold || weight == FontWeight.w700) {
      return FontWeight.w400;
    }
    if (weight == FontWeight.w900 || weight == FontWeight.w800) {
      return FontWeight.w700;
    }
    return weight;
  }

  /// Responsive padding for standard containers/widgets.
  static double getPadding(BuildContext context) {
    final category = getCategory(context);
    switch (category) {
      case DeviceCategory.smallMobile:
        return 12.0;
      case DeviceCategory.mobile:
        return 14.0;
      case DeviceCategory.smallTablet:
        return 14.0;
      case DeviceCategory.largeTablet:
        return 15.0;
      case DeviceCategory.desktop:
        return 16.0;
    }
  }

  /// Responsive icon size.
  static double getIconSize(BuildContext context, {double base = 24.0}) {
    final category = getCategory(context);
    switch (category) {
      case DeviceCategory.smallMobile:
        return base * 0.7;
      case DeviceCategory.mobile:
        return base;
      case DeviceCategory.smallTablet:
        return base * 0.8; // Reduced from 1.25
      case DeviceCategory.largeTablet:
        return base * 0.9;
      case DeviceCategory.desktop:
        return base * 0.9;
    }
  }

  static bool isDesktop(BuildContext context) =>
      getCategory(context) == DeviceCategory.desktop;
}

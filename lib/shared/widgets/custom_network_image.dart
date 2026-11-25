import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class EnhancedNetworkImageWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final String? imageUrl;
  final BoxFit fit;
  final Widget? placeHolderWidget;
  final String? fallbackAssetImage;
  final Widget? fallbackWidget;
  final ImageWidgetBuilder? imageBuilder;
  final bool cacheImage;
  final Duration fadeInDuration;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final bool showLoadingIndicator;
  final bool useShimmerEffect;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final BoxShape shape;

  const EnhancedNetworkImageWidget({
    super.key,
    this.height,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeHolderWidget,
    this.imageBuilder,
    this.width = double.infinity,
    this.fallbackAssetImage,
    this.fallbackWidget,
    this.cacheImage = true,
    this.color,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.borderRadius,
    this.border,
    this.showLoadingIndicator = true,
    this.useShimmerEffect = true,
    this.shimmerBaseColor = const Color(0xFFE0E0E0),
    this.shimmerHighlightColor = const Color(0xFFF5F5F5),
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    // If imageUrl is null or empty, show the fallback asset image

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildContainer(_buildFallback());
    }

    return cacheImage
        ? _buildContainer(
            // On web, use HTML <img> element to avoid CORS issues with XHR.
            // On mobile/desktop, use CachedNetworkImage for caching benefits.
            kIsWeb
                ? Image.network(
                    imageUrl!,
                    height: height,
                    width: width,
                    fit: fit,
                    // Uses <img> HTML element instead of XHR — bypasses CORS
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: height,
                        child: _buildPlaceholder(context),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget();
                    },
                  )
                : CachedNetworkImage(
                    width: width,
                    height: height,
                    imageUrl: imageUrl!,
                    color: color,
                    fit: fit,
                    imageBuilder: imageBuilder,
                    fadeInDuration: fadeInDuration,
                    placeholder: (context, url) => _buildPlaceholder(context),
                    errorWidget: (context, url, error) => _buildErrorWidget(),
                  ),
          )
        : _buildContainer(
            Image.network(
              imageUrl!,
              height: height,
              width: width,
              fit: fit,
              // Always use HTML element on web to bypass CORS
              webHtmlElementStrategy: kIsWeb
                  ? WebHtmlElementStrategy.prefer
                  : WebHtmlElementStrategy.fallback,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: height,
                  child: _buildPlaceholder(context),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            ),
          );
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeHolderWidget != null) {
      return placeHolderWidget!;
    }

    if (useShimmerEffect) {
      return Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            shape: shape,
          ),
        ),
      );
    }

    return showLoadingIndicator
        ? Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : _buildFallback();
  }

  Widget _buildErrorWidget() {
    return _buildFallback();
  }

  Widget _buildFallback() {
    // 1. إذا مررنا Widget جاهز (أيقونة مثلاً) نستخدمه فوراً
    if (fallbackWidget != null) {
      return Center(child: fallbackWidget!);
    }

    // 2. إذا كان المسار ينتهي بـ svg
    if (fallbackAssetImage != null &&
        fallbackAssetImage!.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        fallbackAssetImage!,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }

    // 3. إذا كان صورة عادية (PNG/JPG) أو غير ذلك
    if (fallbackAssetImage != null && fallbackAssetImage!.isNotEmpty) {
      return Image.asset(
        fallbackAssetImage!,
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    }

    // 4. حالة احتياطية أخيرة لو كل شيء فارغ (أيقونة خطأ بسيطة)
    return Icon(
      Icons.broken_image,
      size: height != null ? height! * 0.5 : 24,
      color: Colors.grey,
    );
  }

  Widget _buildContainer(Widget child) {
    if (borderRadius != null || border != null || shape == BoxShape.circle) {
      Widget clippedChild = shape == BoxShape.circle
          ? ClipOval(child: child)
          : ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: child,
            );

      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          border: border,
        ),
        child: clippedChild,
      );
    }
    return child;
  }
}

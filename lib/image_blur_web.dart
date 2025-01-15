library;

import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';

class ImageBlurWeb extends StatefulWidget {
  const ImageBlurWeb({
    super.key,
    required this.placeholder,
    required this.thumbnail,
    required this.image,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.blur = 20,
    this.fadeDuration = const Duration(milliseconds: 800),
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.imageSemanticLabel,
    this.errorWidget,
    this.loadingBuilder,
    this.borderRadius,
    this.boxShadow,
    this.backgroundColor,
    this.onTap,
    this.enableHover = true,
  });

  /// The placeholder image that is displayed while the thumbnail or full image is loading.
  final ImageProvider placeholder;

  /// The thumbnail image that is displayed before the full image is loaded.
  final ImageProvider thumbnail;

  /// The final high-resolution image to display.
  final ImageProvider image;

  /// The width of the widget.
  final double width;

  /// The height of the widget.
  final double height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit fit;

  /// The intensity of the blur effect applied to the thumbnail.
  final double blur;

  /// The duration of the fade animation between the thumbnail and the full image.
  final Duration fadeDuration;

  /// How to align the image within its bounds.
  final AlignmentGeometry alignment;

  /// How the image should be repeated if it does not fill its allocated space.
  final ImageRepeat repeat;

  /// Whether to match the direction of the image to the direction of the surrounding text.
  final bool matchTextDirection;

  /// Whether to exclude the image from the semantics tree.
  final bool excludeFromSemantics;

  /// A semantic label for the image.
  final String? imageSemanticLabel;

  /// A widget to display if an error occurs while loading the image.
  final Widget Function(BuildContext, Object)? errorWidget;

  /// A builder function to display a custom loading indicator while the image is loading.
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;

  /// The border radius of the widget, allowing for rounded corners.
  final BorderRadius? borderRadius;

  /// A list of box shadows to apply to the widget.
  final List<BoxShadow>? boxShadow;

  /// The background color of the widget.
  final Color? backgroundColor;

  /// A callback function that is triggered when the widget is tapped.
  final VoidCallback? onTap;

  /// Whether to enable hover effects for the widget (e.g., for web platforms).
  final bool enableHover;

  @override
  State<ImageBlurWeb> createState() => _ImageBlurWebState();
}

class _ImageBlurWebState extends State<ImageBlurWeb> with SingleTickerProviderStateMixin {
  late ImageStream _imageStream;
  ImageInfo? imageInfo;
  bool isLoading = true;
  bool hasError = false;
  Object? _error;
  bool isHovered = false;

  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();

    // تنظیم کنترلر انیمیشن
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // تنظیم انیمیشن بلور
    _blurAnimation = Tween<double>(
      begin: widget.blur,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    loadImage();
  }

  void loadImage() {
    try {
      _imageStream = widget.image.resolve(ImageConfiguration(
        size: Size(widget.width, widget.height),
      ));

      _imageStream.addListener(
        ImageStreamListener(
          handleImageLoaded,
          onError: handleImageError,
        ),
      );
    } catch (e) {
      handleImageError(e, StackTrace.current);
    }
  }

  void handleImageLoaded(ImageInfo info, bool synchronousCall) {
    setState(() {
      imageInfo = info;
      isLoading = false;
      _controller.forward();
    });
  }

  void handleImageError(Object error, StackTrace? stackTrace) {
    setState(() {
      hasError = true;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => isHovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.enableHover && isHovered ? 1.05 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius,
                  boxShadow: widget.boxShadow ??
                      [
                        if (isHovered)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                      ],
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? BorderRadius.zero,
                  child: buildMainImage(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMainImage() {
    if (hasError && widget.errorWidget != null) {
      return widget.errorWidget!(context, _error!);
    }

    if (isLoading) {
      return buildLoadingImage();
    }

    return Stack(
      children: [
        // تصویر بلور شده با انیمیشن
        AnimatedBuilder(
          animation: _blurAnimation,
          builder: (context, child) {
            return ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Image(
                image: widget.thumbnail,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                alignment: widget.alignment,
                repeat: widget.repeat,
                matchTextDirection: widget.matchTextDirection,
              ),
            );
          },
        ),

        FadeTransition(
          opacity: _controller,
          child: Image(
            image: widget.image,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            alignment: widget.alignment,
            repeat: widget.repeat,
            matchTextDirection: widget.matchTextDirection,
          ),
        ),
      ],
    );
  }

  Widget buildLoadingImage() {
    Widget loadingWidget = Image(
      image: widget.thumbnail,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      alignment: widget.alignment,
      repeat: widget.repeat,
      matchTextDirection: widget.matchTextDirection,
    );

    if (widget.blur > 0) {
      loadingWidget = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: widget.blur,
          sigmaY: widget.blur,
        ),
        child: loadingWidget,
      );
    }

    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(
        context,
        loadingWidget,
        null,
      );
    }

    return Stack(
      children: [
        loadingWidget,
        Positioned.fill(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _imageStream.removeListener(
      ImageStreamListener(
        handleImageLoaded,
        onError: handleImageError,
      ),
    );
    _controller.dispose();
    super.dispose();
  }
}

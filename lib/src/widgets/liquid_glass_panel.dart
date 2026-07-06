import 'dart:ui';

import 'package:flutter/material.dart';

import '../../adaptive_ui_kit.dart';
import '../uitils/glass_colors.dart';

/// Reusable glass panel: blur + tint + specular border + shadow.
/// radius default (32) matches iOS 26's rounder "concentric" corners.
class LiquidGlassPanel extends StatelessWidget {
  final Widget child;
  final double? radius;
  final bool topOnly;
  final EdgeInsetsGeometry? padding;

  /// radius defaults to [AdaptiveUiKitConfig.glass.dialogRadius] when null -
  /// pass null (the default) unless this one panel needs a custom size.
  const LiquidGlassPanel({
    super.key,
    required this.child,
    this.radius,
    this.topOnly = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final effectiveRadius = radius ?? t.dialogRadius;
    final borderRadius = topOnly
        ? BorderRadius.vertical(top: Radius.circular(effectiveRadius))
        : BorderRadius.circular(effectiveRadius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.compose(
          outer: ImageFilter.blur(sigmaX: t.blurSigma, sigmaY: t.blurSigma),
          inner: ColorFilter.matrix(<double>[
            t.saturationBoost,
            0,
            0,
            0,
            0,
            0,
            t.saturationBoost,
            0,
            0,
            0,
            0,
            0,
            t.saturationBoost,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: GlassColors.surface(context),
                borderRadius: borderRadius,
                border: Border.all(
                  color: GlassColors.border(context),
                  width: t.borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor.withValues(alpha: 0.16),
                    blurRadius: t.shadowBlur,
                    offset: t.shadowOffset,
                  ),
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
            ),
            // Specular highlight: soft bright streak along the top edge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: t.highlightStreakHeight,
                  margin: EdgeInsets.symmetric(
                    horizontal: effectiveRadius * 0.4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        GlassColors.highlight(context),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

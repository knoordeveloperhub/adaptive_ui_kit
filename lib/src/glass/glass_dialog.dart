import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../layout/responsive_layout.dart';

// =======================================================================
// iOS 26 LIQUID GLASS KIT - Helper Colors
// =======================================================================
class GlassColors {
  static Color surface(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.white.withValues(
      alpha: isDark ? t.surfaceOpacityDark : t.surfaceOpacityLight,
    );
  }

  static Color border(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.white.withValues(
      alpha: isDark ? t.borderOpacityDark : t.borderOpacityLight,
    );
  }

  /// Bright top edge - the specular highlight that sells the glass look.
  static Color highlight(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.white.withValues(
      alpha: isDark ? t.highlightOpacityDark : t.highlightOpacityLight,
    );
  }

  static Color rowFill(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.white.withValues(
      alpha: isDark ? t.rowFillOpacityDark : t.rowFillOpacityLight,
    );
  }

  static Color text(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? t.textColorDark : t.textColorLight;
  }

  static Color textMuted(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? t.textMutedColorDark : t.textMutedColorLight;
  }
}

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

/// Mirrors Apple's iOS 26 button styles:
/// - `.glass`           -> translucent capsule (secondary actions)
/// - `.glassProminent`  -> solid-tint capsule (primary/destructive)
class _GlassPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  final bool prominent;

  const _GlassPillButton({
    required this.label,
    required this.onTap,
    this.destructive = false,
    this.prominent = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AdaptiveUiKitConfig.glass;
    final isFilled = prominent || destructive;
    final tint = destructive ? t.destructiveColor : t.tintColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: isFilled ? tint : GlassColors.rowFill(context),
          borderRadius: BorderRadius.circular(999),
          border: isFilled
              ? null
              : Border.all(color: GlassColors.highlight(context), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: isFilled ? Colors.white : GlassColors.text(context),
          ),
        ),
      ),
    );
  }
}

/// Simple mount-in scale+fade animation
class _GlassEntryAnimation extends StatefulWidget {
  final Widget child;
  const _GlassEntryAnimation({required this.child});

  @override
  State<_GlassEntryAnimation> createState() => _GlassEntryAnimationState();
}

class _GlassEntryAnimationState extends State<_GlassEntryAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AdaptiveUiKitConfig.glass.entryAnimationDuration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    return ScaleTransition(
      scale: curved,
      child: FadeTransition(opacity: _controller, child: widget.child),
    );
  }
}

/// iOS 26 style confirm dialog
class LiquidGlassDialog {
  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => _GlassEntryAnimation(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveLayout.dialogMaxWidth(ctx),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LiquidGlassPanel(
                radius: AdaptiveUiKitConfig.glass.dialogRadius,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: GlassColors.text(ctx),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: GlassColors.textMuted(ctx),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _GlassPillButton(
                            label: cancelText,
                            onTap: () => Navigator.of(ctx).pop(false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _GlassPillButton(
                            label: confirmText,
                            destructive: isDestructive,
                            prominent: !isDestructive,
                            onTap: () => Navigator.of(ctx).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

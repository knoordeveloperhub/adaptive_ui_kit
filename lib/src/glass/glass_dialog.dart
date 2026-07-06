import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../layout/responsive_layout.dart';
import '../uitils/glass_colors.dart';
import '../widgets/liquid_glass_panel.dart';

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
    String? title,
    String? message,
    Widget? titleWidget,
    Widget? messageWidget,
    String? secondaryMessage,
    Widget? secondaryMessageWidget,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    TextStyle? secondaryMessageStyle,
    TextAlign? titleAlign,
    TextAlign? messageAlign,
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
                    titleWidget ??
                        (title != null
                            ? Text(
                                title,
                                textAlign: titleAlign ?? TextAlign.center,
                                style: titleStyle ??
                                    TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: GlassColors.text(ctx),
                                    ),
                              )
                            : const SizedBox.shrink()),
                    const SizedBox(height: 6),
                    messageWidget ??
                        (message != null
                            ? Text(
                                message,
                                textAlign: messageAlign ?? TextAlign.center,
                                style: messageStyle ??
                                    TextStyle(
                                      fontSize: 14,
                                      color: GlassColors.textMuted(ctx),
                                    ),
                              )
                            : const SizedBox.shrink()),
                    if (secondaryMessage != null ||
                        secondaryMessageWidget != null) ...[
                      const SizedBox(height: 8),
                      secondaryMessageWidget ??
                          Text(
                            secondaryMessage ?? '',
                            textAlign: TextAlign.center,
                            style: secondaryMessageStyle ??
                                TextStyle(
                                  fontSize: 13,
                                  color: GlassColors.textMuted(ctx),
                                ),
                          ),
                    ],
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

// =======================================================================
// iOS 26 LIQUID GLASS KIT - Helper Colors
// =======================================================================
import 'package:flutter/material.dart';

import '../../adaptive_ui_kit.dart';

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

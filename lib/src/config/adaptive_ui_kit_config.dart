import 'package:flutter/material.dart';
import 'liquid_glass_theme.dart';
import 'material_surface_theme.dart';

bool _isApplePlatform(TargetPlatform platform) {
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
}

/// -----------------------------------------------------------------------
/// GLOBAL CONFIG - every color/size/opacity/duration used by the glass
/// kit lives here with a sensible default. Override any field you need;
/// anything you don't set keeps its default automatically.
///
/// Example (set once, e.g. in main() before runApp):
///   AdaptiveUiKitConfig.glass = AdaptiveUiKitConfig.glass.copyWith(
///     tintColor: Colors.purple,
///     destructiveColor: Colors.deepOrange,
///   );
/// -----------------------------------------------------------------------
class AdaptiveUiKitConfig {
  /// Mutable on purpose - set this once at app startup to re-theme
  /// every Liquid Glass component without touching widget code.
  static LiquidGlassTheme glass = const LiquidGlassTheme();

  /// Mutable on purpose - set this once at app startup to control the
  /// background + surfaceTint colors used by every Material dialog/sheet
  /// (confirm dialog, action sheet, multi-select, date/time pickers).
  /// Defaults to plain black/white (light/dark aware) with a subtle
  /// glassy tint - see [MaterialSurfaceTheme] for details and how to
  /// override with your own brand colors.
  static MaterialSurfaceTheme materialSurface = const MaterialSurfaceTheme();

  /// -------------------------------------------------------------------
  /// EXTENSION POINT - add a future UI kit here without touching any
  /// call site (AdaptiveDialog / AdaptiveActionSheet / etc).
  ///
  /// Today the kit is resolved purely from `TargetPlatform`
  /// (iOS/macOS -> Glass, everything else -> Material) unless you
  /// explicitly force it below. When a new package/kit is ready (e.g. a
  /// Fluent kit for Windows, or a custom kit for a specific client),
  /// you only need to:
  ///   1. Add a new value to [AdaptiveUiKit].
  ///   2. Implement the kit's classes (mirror LiquidGlass*/Material*).
  ///   3. Add one `case` in each Adaptive* facade in the "ADAPTIVE
  ///      FACADE" section below.
  ///   4. Optionally override [uiKitResolver] (e.g. from a remote
  ///      config / feature flag) to route to it - no other file needs
  ///      to change.
  /// -------------------------------------------------------------------
  static AdaptiveUiKit Function()? uiKitResolver;

  /// -------------------------------------------------------------------
  /// GLOBAL UI KIT OVERRIDE - set this once (e.g. in main(), a
  /// settings screen, or via remote config) to force every Adaptive*
  /// call to render with a specific UI kit (Glass or Material),
  /// regardless of the device it's actually running on. Leave null to
  /// auto-detect from the real device platform.
  ///
  /// Resolution order (highest priority first):
  ///   1. `uiKit:` passed directly to an individual Adaptive* call.
  ///   2. [uiKitResolver] override, if set.
  ///   3. [forceUiKit] (this field).
  ///   4. Auto-detected from the real device's
  ///      `Theme.of(context).platform`.
  ///
  /// Example:
  ///   AdaptiveUiKitConfig.forceUiKit = AdaptiveUiKit.material;
  /// -------------------------------------------------------------------
  static AdaptiveUiKit? forceUiKit;
}

/// Identifies which visual kit should render the adaptive widgets.
/// Kept as an enum (rather than a bool) so a third/fourth kit can be
/// added later without reworking every call site into nested booleans.
enum AdaptiveUiKit { glass, material }

/// Resolves which kit to use for a given call.
///
/// Priority (first non-null wins):
///   1. [uiKit] - passed directly to this specific call.
///   2. [AdaptiveUiKitConfig.uiKitResolver] - global function override.
///   3. [AdaptiveUiKitConfig.forceUiKit] - global forced UI kit.
///   4. Auto-detected from the real device's
///      `Theme.of(context).platform`.
AdaptiveUiKit resolveUiKit(BuildContext context, [AdaptiveUiKit? uiKit]) {
  if (uiKit != null) return uiKit;

  final override = AdaptiveUiKitConfig.uiKitResolver;
  if (override != null) return override();

  final forced = AdaptiveUiKitConfig.forceUiKit;
  if (forced != null) return forced;

  final real = Theme.of(context).platform;
  return _isApplePlatform(real) ? AdaptiveUiKit.glass : AdaptiveUiKit.material;
}

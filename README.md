# Adaptive UI Kit

A powerful Flutter package for building platform-adaptive user interfaces that automatically switch between design systems based on the target platform.

**Glass (iOS/macOS)** - Beautiful iOS 26-style glassmorphism with blur effects, specular highlights, and custom pickers.

**Material (Android)** - Modern Android Material 3 design with native components and expressive interactions.

## Features

- 🎨 **Auto-Adaptive UI** - Automatically switches between Glass and Material designs based on platform
- 📱 **Platform-Specific Components**:
  - Dialogs (confirm dialogs with custom styling)
  - Action Sheets (iOS action sheet style on iOS/macOS, Material bottom sheet on Android)
  - Date Pickers (custom calendar on iOS/macOS, native Material picker on Android)
  - Time Pickers (custom wheel picker on iOS/macOS, native Material picker on Android)
  - Multi-Select (custom list on iOS/macOS, Material bottom sheet on Android)
- 🎯 **Zero Configuration** - Works out of the box with sensible defaults
- 🎨 **Fully Customizable** - Configure colors, sizes, animations, and more globally
- 🔄 **No State Management Required** - Uses standard Flutter navigation
- 📦 **Zero External Dependencies** - Pure Flutter, no GetX or other state managers needed

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  adaptive_ui_kit: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:adaptive_ui_kit/adaptive_ui_kit.dart';

// Show a confirm dialog
final result = await AdaptiveDialog.showConfirm(
  context: context,
  title: 'Confirm',
  message: 'Are you sure?',
);

// Show an action sheet
await AdaptiveActionSheet.show(
  context: context,
  title: 'Choose an action',
  items: [
    ActionSheetItem(
      label: 'Edit',
      icon: Icons.edit,
      onTap: () => print('Edit tapped'),
    ),
    ActionSheetItem(
      label: 'Delete',
      icon: Icons.delete,
      isDestructive: true,
      onTap: () => print('Delete tapped'),
    ),
  ],
);

// Show a date picker
final date = await AdaptiveDateTimePicker.showDate(
  context: context,
  initialDate: DateTime.now(),
);

// Show a time picker
final time = await AdaptiveTimePicker.show(
  context: context,
  initialTime: TimeOfDay.now(),
);

// Show a multi-select
final selected = await AdaptiveMultiSelect.show(
  context: context,
  title: 'Select items',
  options: [
    const MultiSelectOption(id: '1', label: 'Option 1'),
    const MultiSelectOption(id: '2', label: 'Option 2'),
  ],
);
```

## Customization

### Global Configuration

Configure the Glass theme globally in your `main()` function:

```dart
void main() {
  // Customize Glass theme
  AdaptiveUiKitConfig.glass = AdaptiveUiKitConfig.glass.copyWith(
    tintColor: Colors.purple,
    destructiveColor: Colors.orange,
    blurSigma: 12,
    dialogRadius: 28,
    entryAnimationDuration: Duration(milliseconds: 400),
  );

  // Customize Material surface colors
  AdaptiveUiKitConfig.materialSurface = 
      const MaterialSurfaceTheme(
    backgroundColorLight: Color(0xFFFAFAFA),
    backgroundColorDark: Color(0xFF121212),
  );

  runApp(const MyApp());
}
```

### Force a Specific UI Kit

```dart
// Always use Glass design
AdaptiveUiKitConfig.forceUiKit = AdaptiveUiKit.glass;

// Or pass it to individual calls
final result = await AdaptiveDialog.showConfirm(
  context: context,
  title: 'Title',
  message: 'Message',
  uiKit: AdaptiveUiKit.material, // Force Material for this call
);
```

### Custom UI Kit Resolver

```dart
// Use custom logic to determine which kit to use
AdaptiveUiKitConfig.uiKitResolver = () {
  // Could be based on user preference, feature flags, etc.
  return userPrefersMaterial ? AdaptiveUiKit.material : AdaptiveUiKit.glass;
};
```

## Component Details

### AdaptiveDialog

Confirm dialog with platform-specific styling.

```dart
final result = await AdaptiveDialog.showConfirm(
  context: context,
  title: 'Confirm Action',
  message: 'Do you want to proceed?',
  confirmText: 'Yes',    // Default: 'Confirm'
  cancelText: 'No',      // Default: 'Cancel'
  isDestructive: false,  // Red color when true
);
```

### AdaptiveActionSheet

Bottom sheet with action items.

```dart
await AdaptiveActionSheet.show(
  context: context,
  title: 'Options',  // Optional
  items: [
    ActionSheetItem(
      label: 'Edit',
      icon: Icons.edit,
      onTap: () { ... },
    ),
    ActionSheetItem(
      label: 'Delete',
      icon: Icons.delete,
      isDestructive: true,
      onTap: () { ... },
    ),
  ],
);
```

### AdaptiveDateTimePicker

Date picker with live change callbacks on iOS/macOS.

```dart
final date = await AdaptiveDateTimePicker.showDate(
  context: context,
  initialDate: DateTime.now(),
  minimumDate: DateTime(2020),
  maximumDate: DateTime(2030),
  onChanged: (date) => print('Selected: $date'),  // Live updates on iOS
);
```

### AdaptiveTimePicker

Time picker with 12-hour wheel on iOS/macOS.

```dart
final time = await AdaptiveTimePicker.show(
  context: context,
  initialTime: TimeOfDay.now(),
  labels: UiKitLabels.defaultLabels,  // Customize AM/PM text
);
```

### AdaptiveMultiSelect

Multi-select list with checkmarks.

```dart
final selected = await AdaptiveMultiSelect.show(
  context: context,
  title: 'Select items',
  options: [
    const MultiSelectOption(id: '1', label: 'Option 1'),
    const MultiSelectOption(id: '2', label: 'Option 2'),
  ],
  initiallySelected: ['1'],  // Pre-select items
);
```

## Architecture

The package uses an **Adaptive Facade Pattern**:

1. **Adaptive Layer** - Public API (AdaptiveDialog, AdaptiveActionSheet, etc.)
2. **Platform-Specific Implementations**:
   - **Glass** - iOS/macOS with custom blur, animations, and glass effects
   - **Material** - Android with Material 3 design system
3. **Shared Layer** - Config, themes, layouts, and models
4. **Resolution** - Automatic platform detection or manual override

## Supported Platforms

- ✅ iOS (uses Glass design)
- ✅ macOS (uses Glass design)  
- ✅ Android (uses Material design)
- ✅ Web (auto-selects Material design)
- ✅ Windows (auto-selects Material design)
- ✅ Linux (auto-selects Material design)

## Example App

See the `example/` folder for a complete working example demonstrating all components.

Run the example:

```bash
cd example
flutter run
```

## Customizing Themes

### Glass Theme Properties

```dart
LiquidGlassTheme(
  // Colors
  tintColor: Colors.blue,
  destructiveColor: Colors.red,
  textColorLight: Colors.black,
  textColorDark: Colors.white,
  
  // Opacity
  surfaceOpacityLight: 0.2,
  surfaceOpacityDark: 0.3,
  borderOpacityLight: 0.15,
  borderOpacityDark: 0.25,
  
  // Effects
  blurSigma: 10,
  saturationBoost: 1.1,
  
  // Layout
  dialogRadius: 32,
  sheetRadius: 28,
  borderWidth: 0.5,
  
  // Animation
  entryAnimationDuration: Duration(milliseconds: 300),
)
```

### Material Theme Properties

```dart
MaterialSurfaceTheme(
  backgroundColorLight: Color(0xFFFAFAFA),
  backgroundColorDark: Color(0xFF121212),
  cardColorLight: Color(0xFFFFFFFF),
  cardColorDark: Color(0xFF1E1E1E),
  surfaceTintColorLight: Color(0xFFE8EAF6),
  surfaceTintColorDark: Color(0xFF3F3F46),
)
```

## Responsive Layout

Components automatically adapt to different screen sizes and orientations. Use `ResponsiveLayout` for custom responsive behavior:

```dart
import 'package:adaptive_ui_kit/adaptive_ui_kit.dart';

ResponsiveLayout.dialogMaxWidth(context)   // Max dialog width
ResponsiveLayout.sheetMaxWidth(context)    // Max sheet width
ResponsiveLayout.isWide(context)           // Is screen wide (tablet+)
ResponsiveLayout.isLandscape(context)      // Is landscape orientation
```

## Migration from GetX-based Code

If you were using GetX:

**Before (with GetX):**
```dart
Get.dialog(Widget());
Get.bottomSheet(Widget());
Get.back();
Get.back(result: value);
```

**After (with Adaptive UI Kit):**
```dart
showDialog(context: context, builder: (_) => Widget());
showModalBottomSheet(context: context, builder: (_) => Widget());
Navigator.of(context).pop();
Navigator.of(context).pop(value);
```

All components in this package use standard Flutter navigation patterns (no external dependencies).

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, feature requests, or questions, please open an issue on [GitHub](https://github.com/yourusername/adaptive_ui_kit/issues).

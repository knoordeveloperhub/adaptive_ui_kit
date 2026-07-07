# Adaptive UI Kit

[![pub package](https://img.shields.io/pub/v/adaptive_ui_kit.svg)](https://pub.dev/packages/adaptive_ui_kit)
![Platform](https://img.shields.io/badge/platform-Flutter-blue)
![License](https://img.shields.io/badge/license-MIT-green)

<p align="center">
A powerful Flutter package for building beautiful **platform-adaptive user interfaces** with a single API.
</p>

---

## ✨ Overview

Adaptive UI Kit automatically renders the correct UI for each platform.

| Platform | Design |
|----------|--------|
| iOS | Apple-inspired Glass UI |
| macOS | Apple-inspired Glass UI |
| Android | Material 3 |
| Web | Material |
| Windows | Material |
| Linux | Material |

No platform checks. No duplicate widgets.

---

## 🎬 Demo

<p align="center">
  <img src="https://raw.githubusercontent.com/knoordeveloperhub/adaptive_ui_kit/main/assets/screenshots/demo.gif" width="220">
</p>

---

# Features

- Automatic platform adaptation
- Adaptive Dialog
- Adaptive Action Sheet
- Adaptive Date Picker
- Adaptive Time Picker
- Adaptive Multi Select
- Adaptive Navigation Bar
- Global theme configuration
- Force UI Kit support
- Custom resolver support

---
 
## Integration Guide

To integrate Adaptive UI Kit into your Flutter project:

1. Add the package to `pubspec.yaml`:

```yaml
dependencies:
  adaptive_ui_kit: ^0.0.9
```

2. Import the package:

```dart
import 'package:adaptive_ui_kit/adaptive_ui_kit.dart';
```

3. Optionally configure global theming before `runApp`:

```dart
AdaptiveUiKitConfig.glass = AdaptiveUiKitConfig.glass.copyWith(
  tintColor: Colors.indigo,
  destructiveColor: Colors.red,
);

AdaptiveUiKitConfig.forceUiKit = AdaptiveUiKit.glass;
```

4. Replace or add UI calls using the adaptive API. Examples:

```dart
await AdaptiveDialog.showConfirm(
  context: context,
  // either pass plain text:
  title: 'Confirm',
  message: 'Proceed?'
  // or pass widgets instead:
  titleWidget: Row(children: [Icon(Icons.info), Text('Confirm')]),
);

await AdaptiveActionSheet.show(
  context: context,
  titleWidget: Text('Options'),
  items: [ActionSheetItem(label: 'Edit', icon: Icons.edit, onTap: () {})],
);

final selected = await AdaptiveMultiSelect.show(
  context: context,
  titleWidget: Text('Choose'),
  options: [MultiSelectOption(id: '1', label: 'One', child: Text('One'))],
);

// Adaptive bottom navigation bar example
Widget build(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: AdaptiveNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => setState(() => currentIndex = index),
      items: const [
        AdaptiveNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
        AdaptiveNavItem(icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search'),
        AdaptiveNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
      ],
    ),
    body: _pages[currentIndex],
  );
}
```

Notes:
- For Material date/time pickers you can pass `helpText`, `cancelText`, `confirmText`, and a `builder` for custom theme wrapping.
- Widgets take precedence: if `titleWidget`/`messageWidget`/`child` are provided they'll be used instead of string fallbacks.

---

# Components

| Component | Description |
|------------|-------------|
| AdaptiveDialog | Platform adaptive dialog |
| AdaptiveActionSheet | Adaptive action sheet |
| AdaptiveDateTimePicker | Adaptive date picker |
| AdaptiveTimePicker | Adaptive time picker |
| AdaptiveMultiSelect | Adaptive multi select |
| AdaptiveNavigationBar | Platform adaptive bottom navigation bar |

---

# Architecture

```text
Adaptive Widgets
        │
        ▼
 Platform Resolver
        │
 ┌───────────────┐
 │               │
 ▼               ▼
Glass UI   Material UI
        │
        ▼
 Shared Themes
```

---

## 📸 Screenshots

### Overview

<p align="center">
  <img src="https://raw.githubusercontent.com/knoordeveloperhub/adaptive_ui_kit/main/assets/screenshots/overview.png" width="220">
</p>

### Adaptive Dialog

| iOS (Glass) | Android (Material) |
|-------------|--------------------| 


### Date Picker
 
| <img src="https://raw.githubusercontent.com/knoordeveloperhub/adaptive_ui_kit/main/assets/screenshots/date_picker_glass.png" width="220"> | <img src="https://raw.githubusercontent.com/knoordeveloperhub/adaptive_ui_kit/main/assets/screenshots/date_picker_material.png" width="220"> |

### Time Picker
 
| <img src="https://raw.githubusercontent.com/knoordeveloperhub/adaptive_ui_kit/main/assets/screenshots/time_picker_glass.png" width="220"> | <img src="https://raw.githubusercontent.com/knoordeveloperhub/adaptive_ui_kit/main/assets/screenshots/time_picker_material.png" width="220"> |

---

# Example

```bash
cd example
flutter run
```

---

# Roadmap

- Adaptive Snackbar
- Adaptive Toast
- Adaptive Dropdown
- Adaptive Navigation Components
- Adaptive Form Controls
- Adaptive Search Bar

---

# Why Adaptive UI Kit?

Instead of maintaining separate widgets for every platform, write your UI once and let Adaptive UI Kit deliver the native experience automatically.

---

# Contributing

Contributions, bug reports and feature requests are always welcome.

---

# License

MIT License

---

Made with ❤️ using Flutter.

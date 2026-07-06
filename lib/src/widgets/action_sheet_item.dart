import 'package:flutter/material.dart';

class ActionSheetItem {
  final String label;
  final IconData icon;
  final bool isDestructive;
  final VoidCallback onTap;
  final Widget? child;
  final TextStyle? labelStyle;

  const ActionSheetItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.child,
    this.labelStyle,
  });
}

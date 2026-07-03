import 'package:flutter/material.dart';

class ActionSheetItem {
  final String label;
  final IconData icon;
  final bool isDestructive;
  final VoidCallback onTap;

  const ActionSheetItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}

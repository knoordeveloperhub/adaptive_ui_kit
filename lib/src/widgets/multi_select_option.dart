import 'package:flutter/material.dart';

class MultiSelectOption {
  final String id;
  final String label;
  final Widget? child;
  final TextStyle? labelStyle;

  const MultiSelectOption({
    required this.id,
    required this.label,
    this.child,
    this.labelStyle,
  });
}

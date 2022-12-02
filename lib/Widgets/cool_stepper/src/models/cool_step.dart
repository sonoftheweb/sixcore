import 'package:flutter/material.dart';

class CoolStep {
  final String title;
  final String subtitle;
  final Widget content;
  final String? Function()? validation;
  final bool isHeaderEnabled;
  final Color color;

  CoolStep(
      {required this.title,
      required this.subtitle,
      required this.content,
      required this.validation,
      this.color = Colors.white,
      this.isHeaderEnabled = true});
}

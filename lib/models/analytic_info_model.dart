import 'package:flutter/material.dart';

class AnalyticInfo {
  final String? svgSrc, title;
  final int? count;
  final Color? color;
  final Widget route;

  AnalyticInfo({
    this.svgSrc,
    this.title,
    this.count,
    this.color,
    required this.route,
  });
}

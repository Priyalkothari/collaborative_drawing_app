import 'package:flutter/material.dart';

class DrawingPoint {
  final String id;
  final List<Offset> offsets;
  Color color;
  double thickness;

  DrawingPoint({
    required this.id,
    required this.offsets,
    required this.color,
    required this.thickness,
  });
}
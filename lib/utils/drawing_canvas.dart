import 'package:flutter/material.dart';

import '../model/drawing_point.dart';

class DrawingCanvas extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingCanvas(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      final paint = Paint()
        ..color = point.color
        ..strokeWidth = point.thickness
        ..strokeCap = StrokeCap.round;

      if (point.offsets.length > 1) {
        for (var i = 1; i < point.offsets.length; i++) {
          canvas.drawLine(
            point.offsets[i - 1],
            point.offsets[i],
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
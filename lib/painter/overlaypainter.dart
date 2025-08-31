import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FraktalPainter extends CustomPainter {
  final ui.Image? image;

  FraktalPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: Offset.zero & size,
        image: image!,
        fit: BoxFit.contain,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// ignore: unused_element
class OverlayPainter extends CustomPainter {
  final CustomPainter base;
  final Offset? dragStart;
  final Offset? dragEnd;

  OverlayPainter({required this.base, this.dragStart, this.dragEnd});

  @override
  void paint(Canvas canvas, Size size) {
    base.paint(canvas, size);

    if (dragStart != null && dragEnd != null) {
      final rect = Rect.fromPoints(dragStart!, dragEnd!);
      final paint = Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

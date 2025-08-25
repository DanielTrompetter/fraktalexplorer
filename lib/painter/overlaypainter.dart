import 'package:flutter/material.dart';

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

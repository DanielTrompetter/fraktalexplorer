import 'package:flutter/material.dart';

class MandelbrotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(20),
    );
    canvas.save();
    canvas.clipRRect(rrect);

    final int w = size.width.toInt();
    final int h = size.height.toInt();
    final paint = Paint();

    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        final cx = (x - w / 2) / (w / 4);
        final cy = (y - h / 2) / (h / 4);
        int iter = 0;
        double zx = 0, zy = 0;

        while (zx * zx + zy * zy < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = temp;
          iter++;
        }

        paint.color = Color.fromARGB(255, iter * 2 % 255, iter * 5 % 255, iter * 3 % 255);
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


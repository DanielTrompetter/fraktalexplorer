import 'package:flutter/material.dart';

class JuliaPainter extends CustomPainter {
  final double cx;
  final double cy;

  JuliaPainter({this.cx = -0.7, this.cy = 0.27015}); // Beispielwert für c

  @override
  void paint(Canvas canvas, Size size) {
    final int w = size.width.toInt();
    final int h = size.height.toInt();
    final paint = Paint();

    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        // Koordinaten in komplexe Ebene umrechnen
        double zx = (x - w / 2) / (w / 4);
        double zy = (y - h / 2) / (h / 4);
        int iter = 0;

        while (zx * zx + zy * zy < 4 && iter < 100) {
          final temp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = temp;
          iter++;
        }

        // Farbgebung basierend auf Iteration
        paint.color = Color.fromARGB(255, iter * 9 % 255, iter * 2 % 255, iter * 5 % 255);
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

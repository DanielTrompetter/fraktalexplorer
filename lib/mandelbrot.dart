import 'dart:async';
import 'dart:typed_data';

Future<Uint8List> calcMandelbrot(int width, int height, int maxIterations) async {
  final pixels = Uint8List(width * height * 4);

  // Symmetrischer Bereich um (0, 0)
  final double left = -1.5;
  final double right = 1.5;
  final double top = 1.5;
  final double bottom = -1.5;

  final scaleX = (right - left) / width;
  final scaleY = (top - bottom) / height;

  for (int x = 0; x < width; x++) {
    final double cx = left + x * scaleX;

    for (int y = 0; y < height; y++) {
      final double cy = bottom + y * scaleY; // Y-Achse korrigiert

      int iter = 0;
      double zx = 0;
      double zy = 0;

      while (zx * zx + zy * zy < 4 && iter < maxIterations) {
        final temp = zx * zx - zy * zy + cx;
        zy = 2 * zx * zy + cy;
        zx = temp;
        iter++;
      }

      final ptr = (y * width + x) * 4;
      pixels[ptr]     = (iter % 256);               // Rot
      pixels[ptr + 1] = ((iter * 5) % 256);         // Grün
      pixels[ptr + 2] = ((iter * 13) % 256);        // Blau
      pixels[ptr + 3] = 255;

    }
  }
  print("Neues Mandedlbrot mit $maxIterations berechnet!");
  return pixels;
}

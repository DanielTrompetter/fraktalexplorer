import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

enum FraktalTyp
{
  mandelbrot,
  juliaMenge,
}

Future<ui.Image> renderImage(ui.Rect? rect, ui.Size size, FraktalTyp typ) async 
{
  print(rect);
  final int width = size.width.toInt();
  final int height = size.height.toInt();
  final pixels = Uint8List(width * height * 4); // RGBA

  // Fallback: Standardbereich für Mandelbrot (-2.0 bis 1.0, -1.5 bis 1.5)
  final double left = rect?.left ?? -2.0;
  final double right = rect?.right ?? 1.0;
  final double top = rect?.top ?? -1.5;
  final double bottom = rect?.bottom ?? 1.5;

  final double scaleX = (right - left) / width;
  final double scaleY = (bottom - top) / height;


  for (int x = 0; x < width; x++) {
    // Interpolation von x in den komplexen Bereich
    double cx = left + x * scaleX;

    for (int y = 0; y < height; y++) {
      // Interpolation von y in den komplexen Bereich
      double cy = top + y * scaleY;

      if (typ == FraktalTyp.juliaMenge) {
        final cRe = -0.7;
        final cIm = 0.27015;
        double zx = cx;
        double zy = cy;
        int iter = 0;

        while (zx * zx + zy * zy < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cRe;
          zy = 2 * zx * zy + cIm;
          zx = temp;
          iter++;
        }

        final ptr = (y * width + x) * 4;
        pixels[ptr] = iter * 2 % 255;
        pixels[ptr + 1] = iter * 5 % 255;
        pixels[ptr + 2] = iter * 3 % 255;
        pixels[ptr + 3] = 255;
      } else {
        double zx = 0, zy = 0;
        int iter = 0;

        while ((zx * zx + zy * zy) < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = temp;
          iter++;
        }

        final ptr = (y * width + x) * 4;
        pixels[ptr] = iter * 2 % 255;
        pixels[ptr + 1] = iter * 5 % 255;
        pixels[ptr + 2] = iter * 3 % 255;
        pixels[ptr + 3] = 255;
      }
    }
  }

  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    pixels,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}

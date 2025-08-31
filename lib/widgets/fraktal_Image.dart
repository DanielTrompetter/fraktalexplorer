import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

enum FraktalTyp {
  mandelbrot,
  juliaMenge,
}

/// Wandelt ein Pixel-Rect in einen komplexen Bereich um
ui.Rect pixelToComplexRect(ui.Rect pixelRect, ui.Size size, FraktalTyp typ) {
  final double left = typ == FraktalTyp.mandelbrot ? -2.0 : -1.5;
  final double right = typ == FraktalTyp.mandelbrot ? 1.0 : 1.5;
  final double top = typ == FraktalTyp.mandelbrot ? -1.5 : 1.5;
  final double bottom = typ == FraktalTyp.mandelbrot ? 1.5 : -1.5;

  final scaleX = (right - left) / size.width;
  final scaleY = (top - bottom) / size.height;

  final complexLeft = left + pixelRect.left * scaleX;
  final complexRight = left + pixelRect.right * scaleX;
  final complexTop = top - pixelRect.top * scaleY;
  final complexBottom = top - pixelRect.bottom * scaleY;

  return ui.Rect.fromLTRB(complexLeft, complexTop, complexRight, complexBottom);
}

Future<ui.Image> renderImage(ui.Rect? rect, ui.Size size, FraktalTyp typ) async 
{
  final int width = size.width.toInt();
  final int height = size.height.toInt();
  final pixels = Uint8List(width * height * 4); // RGBA

  // Fallback: gesamter Bildbereich in Pixelkoordinaten
  final ui.Rect pixelRect = rect ?? ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

  // Umrechnung in komplexen Bereich
  final ui.Rect complexRect = pixelToComplexRect(pixelRect, size, typ);
  print(complexRect);

  final double scaleX = (complexRect.right - complexRect.left) / width;
  final double scaleY = (complexRect.bottom - complexRect.top) / height;

  for (int x = 0; x < width; x++) {
    final double cx = complexRect.left + x * scaleX;

    for (int y = 0; y < height; y++) {
      final double cy = complexRect.top + y * scaleY;

      int iter = 0;
      double zx, zy;

      if (typ == FraktalTyp.juliaMenge) {
        zx = cx;
        zy = cy;
        const cRe = -0.7;
        const cIm = 0.27015;

        while (zx * zx + zy * zy < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cRe;
          zy = 2 * zx * zy + cIm;
          zx = temp;
          iter++;
        }
      } else {
        zx = 0;
        zy = 0;

        while (zx * zx + zy * zy < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = temp;
          iter++;
        }
      }

      final ptr = (y * width + x) * 4;
      pixels[ptr] = iter * 2 % 255;
      pixels[ptr + 1] = iter * 5 % 255;
      pixels[ptr + 2] = iter * 3 % 255;
      pixels[ptr + 3] = 255;
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

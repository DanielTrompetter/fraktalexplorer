import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

enum FraktalTyp
{
  mandelbrot,
  juliaMenge,
}

Future<ui.Image> renderImage(ui.Rect? rect, ui.Size size, FraktalTyp typ) async {
  final int width = size.width.toInt();
  final int height = size.height.toInt();
  final pixels = Uint8List(width * height * 4); // RGBA

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      double cx = (x - width / 2) / (width / 4);
      double cy = (y - height / 2) / (height / 4);

      if (typ == FraktalTyp.juliaMenge) {
        // Julia
        final cRe = -0.7;
        final cIm = 0.27015;
        cx = cx;
        cy = cy;
        double zx = cx;
        double zy = cy;
        int iter = 0;

        while (zx * zx + zy * zy < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cRe;
          zy = 2 * zx * zy + cIm;
          zx = temp;
          iter++;
        }

        final i = (y * width + x) * 4;
        pixels[i] = iter * 2 % 255;
        pixels[i + 1] = iter * 5 % 255;
        pixels[i + 2] = iter * 3 % 255;
        pixels[i + 3] = 255;
      } else {
        // Mandelbrot
        double zx = 0, zy = 0;
        int iter = 0;

        while (zx * zx + zy * zy < 4 && iter < 1024) {
          final temp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = temp;
          iter++;
        }

        final i = (y * width + x) * 4;
        pixels[i] = iter * 2 % 255;
        pixels[i + 1] = iter * 5 % 255;
        pixels[i + 2] = iter * 3 % 255;
        pixels[i + 3] = 255;
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

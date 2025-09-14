import 'dart:async';
import 'dart:typed_data';

Future<Uint8List> calcJulia(int width, int height, int maxIterations) async 
{
  final pixels = Uint8List(width * height * 4);

  final double left = -1.5;
  final double right = 1.5;
  final double top =  1.5;
  final double bottom = -1.5;

  final scaleX = (right - left) / width;
  final scaleY = (top - bottom) / height;

  for (int x = 0; x < width; x++) 
  {
    final double cx = left + x * scaleX;

    for (int y = 0; y < height; y++) 
    {
      final double cy = bottom + y * scaleY;

      int iter = 0;
      double zx, zy;

      zx = cx;
      zy = cy;
      const cRe = -0.7;
      const cIm = 0.27015;

      while (zx * zx + zy * zy < 4 && iter < maxIterations) 
      {
        final temp = zx * zx - zy * zy + cRe;
        zy = 2 * zx * zy + cIm;
        zx = temp;
        iter++;
       }

      final ptr = (y * width + x) * 4;
      final gray = (iter / 1024 * 255).toInt();
      pixels[ptr]     = gray;
      pixels[ptr + 1] = (gray * 0.8).toInt();
      pixels[ptr + 2] = (gray * 0.6).toInt();
      pixels[ptr + 3] = 255;
    }
  }
  return pixels;
}

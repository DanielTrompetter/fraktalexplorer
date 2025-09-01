import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../juliaMenge.dart';
import '../mandelbrot.dart';

enum FraktalTyp {
  mandelbrot,
  juliaMenge,
}

Future<ui.Image> renderImage(int width, int height, FraktalTyp typ) async 
{
  Uint8List pixels;
  if(typ ==FraktalTyp.mandelbrot)
  {
    pixels = await calcMandelbrot(width, height);
  }
  else
  {
    pixels = await calcJulia(width, height);
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

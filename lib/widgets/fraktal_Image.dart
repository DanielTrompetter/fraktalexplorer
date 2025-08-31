import 'package:flutter/material.dart';
import 'package:fraktalexplorer/painter/julia_painter.dart';
import 'dart:ui' as ui;
import '../painter/mandelbrot_painter.dart';

enum FraktalTyp
{
  MandelBrot,
  Julia
}

FraktalTyp aktuellerTyp = FraktalTyp.MandelBrot;

Future<ui.Image> renderImage(Size size, FraktalTyp typ) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final painter = typ == FraktalTyp.MandelBrot?MandelbrotPainter():JuliaPainter();
  painter.paint(canvas, size);

  final picture = recorder.endRecording();
  return await picture.toImage(size.width.toInt(), size.height.toInt());
}
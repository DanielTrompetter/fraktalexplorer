import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../painter/mandelbrot_painter.dart';


Future<ui.Image> renderImage(Size size) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final painter = MandelbrotPainter();
  painter.paint(canvas, size);

  final picture = recorder.endRecording();
  return await picture.toImage(size.width.toInt(), size.height.toInt());
}
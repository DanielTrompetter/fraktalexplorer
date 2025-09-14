import 'package:flutter/material.dart';
import 'widgets/fraktal_Image.dart';
import 'widgets/bigbutton.dart';
import 'dart:ui' as ui;

/*
import 'package:device_preview/device_preview.dart';
void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => FraktalApp(),
    ),
  );
}
*/

import 'dart:io';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    setWindowTitle('Fraktal Explorer');
    setWindowMinSize(const Size(640, 480));
    setWindowMaxSize(const Size(1920, 1080));
    setWindowFrame(const Rect.fromLTWH(100, 100, 1000, 800));
  }

  runApp(const FraktalApp());
}

class FraktalApp extends StatefulWidget {
  const FraktalApp({super.key});

  @override
  State<FraktalApp> createState() => FraktalAppState();
}

class FraktalAppState extends State<FraktalApp> {
  FraktalTyp aktuellerTyp = FraktalTyp.mandelbrot;
  ui.Image? image;
  Offset? zoomCenter;
  double zoomFactor = 1.0;
  int maxIterations = 512; // Startwert
  Duration? renderDuration;

  @override
  void initState() {
    super.initState();
    generateImage();
  }

  Future<Duration> generateImage() async {
    final startTime = DateTime.now();
    final img = await renderImage(500, 500, maxIterations, aktuellerTyp);
    final endTime = DateTime.now();
    setState(() {
      image = img;
      zoomFactor = 1.0;
      zoomCenter = null;
    });
    return endTime.difference(startTime);
  }

  Future<void> changeFractalType(FraktalTyp typ) async {
    setState(() {
      aktuellerTyp = typ;
      zoomFactor = 1.0;
      zoomCenter = null;
    });
    renderDuration = await generateImage();
  }

void handleTapDown(TapDownDetails details) {
  final localPos = details.localPosition;

  setState(() {
    if (zoomCenter != null && zoomFactor > 1.0 && image != null) {
      zoomCenter = transformToOriginal(localPos, zoomCenter!, zoomFactor, Size(image!.width.toDouble(), image!.height.toDouble()));
    } else {
      zoomCenter = localPos;
    }
    zoomFactor += 1.0;
  });
}

  void _resetZoom() {
    setState(() {
      zoomFactor = 1.0;
      zoomCenter = null;
    });
  }

@override
Widget build(BuildContext context) 
{
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(title: const Text('Fraktal Viewer')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔲 Umschalt-Buttons für Fraktaltyp
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BigButton(
                    label: 'Mandelbrot',
                    isActive: aktuellerTyp == FraktalTyp.mandelbrot,
                    onPressed: () => changeFractalType(FraktalTyp.mandelbrot),
                  ),
                  const SizedBox(width: 16),
                  BigButton(
                    label: 'Julia-Menge',
                    isActive: aktuellerTyp == FraktalTyp.juliaMenge,
                    onPressed: () => changeFractalType(FraktalTyp.juliaMenge),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🔲 Bild + Slider nebeneinander
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: handleTapDown,
                    child: MouseRegion(
                      child: SizedBox(
                        width: 500,
                        height: 500,
                        child: image != null
                            ? (zoomFactor > 1.0 && zoomCenter != null
                                ? CustomPaint(
                                    painter: ZoomPainter(image!, zoomCenter!, zoomFactor),
                                  )
                                : RawImage(image: image))
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      const Text(
                        'Iterationen',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 500,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: maxIterations.toDouble(),
                            min: 256,
                            max: 4096,
                            divisions: ((4096 - 256) ~/ 256),
                            label: '$maxIterations',
                            onChanged: (value) async {
                              setState(() {
                                maxIterations = value.round();
                              });
                              renderDuration = await generateImage();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 🔲 Infozeile
              Text(
                'Iterationen: $maxIterations'
                '${renderDuration != null ? ' | Dauer: ${renderDuration!.inMilliseconds} ms' : ''}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // 🔲 Zoom zurücksetzen
              BigButton(
                isActive: zoomFactor != 1.0,
                label: 'Zoom zurücksetzen',
                onPressed: _resetZoom,
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
class ZoomPainter extends CustomPainter {
  final ui.Image image;
  final Offset center;
  final double zoom;

  ZoomPainter(this.image, this.center, this.zoom);

  @override
  void paint(Canvas canvas, Size size) {
    final srcSize = Size(size.width / zoom, size.height / zoom);
    final srcOffset = Offset(
      (center.dx - srcSize.width / 2).clamp(0, image.width - srcSize.width),
      (center.dy - srcSize.height / 2).clamp(0, image.height - srcSize.height),
    );

    final srcRect = Rect.fromLTWH(srcOffset.dx, srcOffset.dy, srcSize.width, srcSize.height);
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset transformToOriginal(Offset clickPos, Offset zoomCenter, double zoomFactor, Size imageSize) {
  final srcSize = Size(imageSize.width / zoomFactor, imageSize.height / zoomFactor);
  final topLeft = Offset(
    (zoomCenter.dx - srcSize.width / 2).clamp(0, imageSize.width - srcSize.width),
    (zoomCenter.dy - srcSize.height / 2).clamp(0, imageSize.height - srcSize.height),
  );

  return Offset(
    topLeft.dx + clickPos.dx / zoomFactor,
    topLeft.dy + clickPos.dy / zoomFactor,
  );
}

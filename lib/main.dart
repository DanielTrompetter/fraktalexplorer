import 'package:flutter/material.dart';
import 'widgets/fraktal_Image.dart';
import 'widgets/bigbutton.dart';
import 'dart:ui' as ui;
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => FraktalApp(),
    ),
  );
}


class FraktalApp extends StatefulWidget {
  const FraktalApp({super.key});

  @override
  State<FraktalApp> createState() => _FraktalAppState();
}

class _FraktalAppState extends State<FraktalApp> {
  FraktalTyp aktuellerTyp = FraktalTyp.mandelbrot;
  ui.Image? image;
  Offset? zoomCenter;
  double zoomFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    final img = await renderImage(500, 500, aktuellerTyp);
    setState(() {
      image = img;
      zoomFactor = 1.0;
      zoomCenter = null;
    });
  }

  void _wechselTyp(FraktalTyp typ) {
    setState(() {
      aktuellerTyp = typ;
      zoomFactor = 1.0;
      zoomCenter = null;
    });
    _generateImage();
  }

void _handleTapDown(TapDownDetails details) {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(title: const Text('Fraktal Viewer')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BigButton(
                    label: 'Mandelbrot',
                    isActive: aktuellerTyp == FraktalTyp.mandelbrot,
                    onPressed: () => _wechselTyp(FraktalTyp.mandelbrot),
                  ),
                  const SizedBox(width: 16),
                  BigButton(
                    label: 'Juliamenge',
                    isActive: aktuellerTyp == FraktalTyp.juliaMenge,
                    onPressed: () => _wechselTyp(FraktalTyp.juliaMenge),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTapDown: _handleTapDown,
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
              const SizedBox(height: 16),
              BigButton
              (
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

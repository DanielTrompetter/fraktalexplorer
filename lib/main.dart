import 'package:flutter/material.dart';
import 'widgets/fraktal_Image.dart';
import 'widgets/bigbutton.dart';
import 'painter/overlaypainter.dart';
import 'dart:ui' as ui;


void main() => runApp(const MandelbrotApp());

class MandelbrotApp extends StatefulWidget {
  const MandelbrotApp({super.key});

  @override
  State<MandelbrotApp> createState() => _MandelbrotAppState();
}

class _MandelbrotAppState extends State<MandelbrotApp> {
  FraktalTyp aktuellerTyp = FraktalTyp.MandelBrot;
  ui.Image? image;
  Offset? dragStart;
  Offset? dragEnd;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    final img = await renderImage(const Size(300, 300), aktuellerTyp);
    setState(() => image = img);
  }

  void _wechselTyp(FraktalTyp typ) {
    setState(() => aktuellerTyp = typ);
    _generateImage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(title: const Text('Fraktal Viewer')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigButton(
                  label: 'Mandelbrot',
                  isActive: aktuellerTyp == FraktalTyp.MandelBrot,
                  onPressed: () => _wechselTyp(FraktalTyp.MandelBrot),
                ),
                const SizedBox(width: 16),
                BigButton(
                  label: 'Juliamenge',
                  isActive: aktuellerTyp == FraktalTyp.Julia,
                  onPressed: () => _wechselTyp(FraktalTyp.Julia),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onPanStart: (details) {
                setState(() => dragStart = details.localPosition);
              },
              onPanUpdate: (details) {
                setState(() => dragEnd = details.localPosition);
              },
              onPanEnd: (_) {
                // Optional: Zoom oder Reset
              },
              child: CustomPaint(
                painter: OverlayPainter(
                  base: FraktalPainter(image),
                  dragStart: dragStart,
                  dragEnd: dragEnd,
                ),
                child: SizedBox(
                  width: image?.width.toDouble() ?? 300,
                  height: image?.height.toDouble() ?? 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FraktalImageWidget extends StatefulWidget {
  final FraktalTyp typ;

  const FraktalImageWidget({super.key, required this.typ});

  @override
  State<FraktalImageWidget> createState() => _FraktalImageWidgetState();
}

class _FraktalImageWidgetState extends State<FraktalImageWidget> {
  ui.Image? image;

  @override
  void didUpdateWidget(covariant FraktalImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.typ != widget.typ) {
      _generateImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    final img = await renderImage(const Size(300, 300), widget.typ);
    setState(() => image = img);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: image == null
          ? const CircularProgressIndicator()
          : RawImage(image: image, scale: 1.0),
    );
  }
}


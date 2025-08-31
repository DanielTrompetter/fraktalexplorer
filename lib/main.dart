import 'package:flutter/material.dart';
import 'widgets/fraktal_Image.dart';
import 'widgets/bigbutton.dart';
import 'painter/overlaypainter.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:window_size/window_size.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    setWindowTitle('Fraktal Explorer');
    setWindowMinSize(const Size(640, 480));
    setWindowMaxSize(const Size(1920, 1080));
    setWindowFrame(const Rect.fromLTWH(100, 100, 1000, 800)); // Position + Größe
  }

  runApp(const FraktalApp());
}


class FraktalApp extends StatefulWidget {
  const FraktalApp({super.key});

  @override
  State<FraktalApp> createState() => _FraktalAppState();
}

class _FraktalAppState extends State<FraktalApp> {
  FraktalTyp aktuellerTyp = FraktalTyp.mandelbrot;
  ui.Image? image;
  Offset? dragStart;
  Offset? dragEnd;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    final img = await renderImage(null, const Size(500, 500), aktuellerTyp);
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
              onPanStart: (details) {
                setState(() => dragStart = details.localPosition);
              },
              onPanUpdate: (details) {
                setState(() => dragEnd = details.localPosition);
              },
              onPanEnd: (_) async {
                if (dragStart != null && dragEnd != null) {
                  final rect = Rect.fromPoints(dragStart!, dragEnd!);
                  final neueImage = await renderImage(rect, Size(500, 500), aktuellerTyp);

                  setState(() {
                    image = neueImage;
                    dragStart = null;
                    dragEnd = null;
                  });
                }
              },
              child: CustomPaint(
                painter: OverlayPainter(
                  base: FraktalPainter(image),
                  dragStart: dragStart,
                  dragEnd: dragEnd,
                ),
                child: SizedBox(
                  width: image?.width.toDouble() ?? 500,
                  height: image?.height.toDouble() ?? 500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

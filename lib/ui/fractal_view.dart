import 'package:flutter/material.dart';
import '../painter/overlaypainter.dart';
import '../widgets/bigbutton.dart';
import '../painter/mandelbrot_painter.dart';
import '../painter/julia_painter.dart';

class FractalView extends StatefulWidget {
  const FractalView({super.key});

  @override
  State<FractalView> createState() => _FractalViewState();
}

class _FractalViewState extends State<FractalView> {
  Offset? dragStart;
  Offset? dragEnd;

  String activeFractal = 'mandelbrot';

  CustomPainter painterWithRect(CustomPainter basePainter) {
    return OverlayPainter(
      base: basePainter,
      dragStart: dragStart,
      dragEnd: dragEnd,
    );
  }
  @override
  Widget build(BuildContext context) {
    final CustomPainter painter = (activeFractal == 'mandelbrot')
        ? MandelbrotPainter()
        : JuliaPainter(cx: -0.7, cy: 0.27015);

    return Scaffold(
      appBar: AppBar(title: const Text('Fraktal Explorer')),
      backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  dragStart = details.localPosition;
                  dragEnd = details.localPosition;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  dragEnd = details.localPosition;
                });
              },
              onPanEnd: (details) {
                print('Zoom rect: ${Rect.fromPoints(dragStart!, dragEnd!)}');
              },
              child: CustomPaint(
                painter: painterWithRect(painter),
              ),
            ),
          ),
        ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BigButton(
                    label: 'Mandelbrot',
                    isActive: activeFractal == 'mandelbrot',
                    onPressed: () => setState(() => activeFractal = 'mandelbrot'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BigButton(
                    label: 'Julia',
                    isActive: activeFractal == 'julia',
                    onPressed: () => setState(() => activeFractal = 'julia'),
                  ),
                ),
              ),
            ],
          ),
       ],
      ),
    ); 
  }
}



import 'package:flutter/material.dart';
import '../painter/mandelbrot_painter.dart';
import '../painter/julia_painter.dart';

class FractalView extends StatefulWidget {
  const FractalView({super.key});

  @override
  State<FractalView> createState() => _FractalViewState();
}

class _FractalViewState extends State<FractalView> {
  String activeFractal = 'mandelbrot';

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
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 10,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: CustomPaint(painter: painter),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => activeFractal = 'mandelbrot'),
                child: const Text('Mandelbrot'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => setState(() => activeFractal = 'julia'),
                child: const Text('Julia'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

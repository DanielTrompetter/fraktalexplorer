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
            child: CustomPaint(painter: painter),
            )
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0, // Schatten kommt vom Container
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: activeFractal == 'mandelbrot' ? Colors.orange : Colors.white,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => setState(() => activeFractal = 'mandelbrot'),
                      child: const Text('Mandelbrot'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: activeFractal != 'mandelbrot' ? Colors.orange : Colors.white,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => setState(() => activeFractal = 'julia'),
                      child: const Text('Julia'),
                    ),
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

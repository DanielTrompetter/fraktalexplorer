import 'package:flutter/material.dart';
import 'ui/fractal_view.dart';

void main() {
  runApp(const MandelbrotApp());
}

class MandelbrotApp extends StatelessWidget {
  const MandelbrotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fraktal Explorer',
      theme: ThemeData.dark(),
      home: const FractalView(),
    );
  }
}

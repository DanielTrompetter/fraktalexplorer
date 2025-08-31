import 'package:flutter/material.dart';
import 'widgets/fraktalImage.dart';
import 'dart:ui' as ui;

void main() => runApp(const MandelbrotApp());

class MandelbrotApp extends StatelessWidget {
  const MandelbrotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(title: Text('Mandelbrot')),
        body: FraktalImageWidget(),
      ),
    );
  }
}



class FraktalImageWidget extends StatefulWidget {
  const FraktalImageWidget({super.key});

  @override
  State<FraktalImageWidget> createState() => _FraktalImageWidgetState();
}

class _FraktalImageWidgetState extends State<FraktalImageWidget> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    final img = await renderImage(const Size(300, 300));
    setState(() => image = img);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: image == null
          ? const CircularProgressIndicator()
          : RawImage(
              image: image,
              scale: 1.0, // Hier kannst du skalieren!
            ),
    );
  }
}


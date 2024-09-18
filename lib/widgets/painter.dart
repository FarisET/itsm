import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawingCanvas extends StatefulWidget {
  final ImageStream imageStream;

  DrawingCanvas({required this.imageStream});

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset?> points = [];
  ui.Image? _image;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    widget.imageStream.addListener(ImageStreamListener((imageInfo, _) {
      setState(() {
        _image = imageInfo.image;
        _isImageLoaded = true;
      });
    }));
  }

  Future<ui.Image> _exportImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(const Offset(0, 0),
            Offset(_image!.width.toDouble(), _image!.height.toDouble())));

    // Draw the image
    final paint = Paint();
    canvas.drawImage(_image!, Offset.zero, paint);

    // Draw the points
    final drawPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, drawPaint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(_image!.width, _image!.height);

    // Convert the image to byte data
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imgBytes = byteData!.buffer.asUint8List();

    // Show the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Image Preview'),
            content: Image.memory(imgBytes),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isImageLoaded
                ? () async {
                    final editedImage = await _exportImage();
                    Navigator.pop(context, editedImage);
                  }
                : null,
          )
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final offset = renderBox.globalToLocal(details.localPosition);
            points.add(offset);
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null); // Indicates end of drawing stroke
          });
        },
        child: _isImageLoaded
            ? Center(
                child: FittedBox(
                  fit: BoxFit
                      .contain, // Ensure the image fits without distortion
                  child: SizedBox(
                    width: _image!.width.toDouble(),
                    child: AspectRatio(
                      aspectRatio: _image!.width / _image!.height,
                      child: CustomPaint(
                        size: Size(_image!.width.toDouble(),
                            _image!.height.toDouble()),
                        painter: DrawingPainter(points, _image),
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final ui.Image? image;

  DrawingPainter(this.points, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      // Draw the image
      final paint = Paint();
      canvas.drawImage(image!, Offset.zero, paint);

      // Draw the points
      final drawPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      // points.add(Offset(0, 0));

      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          canvas.drawLine(points[i]!, points[i + 1]!, drawPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

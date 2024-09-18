import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawingCanvas extends StatefulWidget {
  final ImageStream imageStream;

  DrawingCanvas({required this.imageStream});

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<List<Offset?>> strokes = [];
  List<Offset?> currentStroke = [];
  ui.Image? _image;
  bool _isImageLoaded = false;
  double scaleFactor = 1.0;
  Offset imageOffset = Offset.zero;
  Color penColor = Colors.red;

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
        _calculateScaleAndOffset(context, _image!);
      });
    }));
  }

  void _calculateScaleAndOffset(BuildContext context, ui.Image image) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        150; // Adjusted height to accommodate buttons and note
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    final scaleWidth = screenWidth / imageWidth;
    final scaleHeight = screenHeight / imageHeight;

    scaleFactor = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;

    final fittedWidth = imageWidth * scaleFactor;
    final fittedHeight = imageHeight * scaleFactor;

    imageOffset = Offset(
      (screenWidth - fittedWidth) / 2,
      (screenHeight - fittedHeight) / 2,
    );
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

    // Draw the strokes
    final drawPaint = Paint()
      ..color = penColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        if (stroke[i] != null && stroke[i + 1] != null) {
          canvas.drawLine(stroke[i]!, stroke[i + 1]!, drawPaint);
        }
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(_image!.width, _image!.height);

    // Convert the image to byte data
    //final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    //final Uint8List imgBytes = byteData!.buffer.asUint8List();

    // Show the dialog
    // await showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Image Preview'),
    //         content: Image.memory(imgBytes),
    //         actions: <Widget>[
    //           TextButton(
    //             child: Text('OK'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     });

    return img;
  }

  void _changePenColor(Color color) {
    setState(() {
      penColor = color;
    });
  }

  void _undo() {
    setState(() {
      if (strokes.isNotEmpty) {
        strokes.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).secondaryHeaderColor),
          onPressed: () {
            // Add your navigation logic here, such as pop or navigate back
            Navigator.of(context).pop();
          },
        ),
        title: Text("Edit Image",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).secondaryHeaderColor,
            )),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/safify_icon.png'),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  currentStroke = [];
                  final RenderBox renderBox =
                      context.findRenderObject() as RenderBox;
                  final localPosition =
                      renderBox.globalToLocal(details.localPosition);
                  final adjustedPosition =
                      (localPosition - imageOffset) / scaleFactor;
                  currentStroke.add(adjustedPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  final RenderBox renderBox =
                      context.findRenderObject() as RenderBox;
                  final localPosition =
                      renderBox.globalToLocal(details.localPosition);
                  final adjustedPosition =
                      (localPosition - imageOffset) / scaleFactor;
                  if (adjustedPosition.dx >= 0 &&
                      adjustedPosition.dx <= _image!.width &&
                      adjustedPosition.dy >= 0 &&
                      adjustedPosition.dy <= _image!.height) {
                    currentStroke.add(adjustedPosition);
                    if (strokes.isNotEmpty && strokes.last == currentStroke) {
                      strokes.removeLast();
                    }
                    strokes.add(currentStroke);
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  currentStroke.add(null); // Indicates end of drawing stroke
                  strokes.add(currentStroke);
                });
              },
              child: _isImageLoaded
                  ? Center(
                      child: CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              150, // Adjusted height to accommodate buttons and note
                        ),
                        painter: DrawingPainter(strokes, _image, scaleFactor,
                            imageOffset, penColor),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Note: Circle the object you are referring to in the image.',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.color_lens),
                        onPressed: _showColorPicker,
                        tooltip: 'Pen Color',
                      ),
                      IconButton(
                        icon: Icon(Icons.undo),
                        onPressed: _undo,
                        tooltip: 'Undo',
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            strokes.clear();
                          });
                        },
                        tooltip: 'Cancel',
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: _isImageLoaded
                            ? () async {
                                final editedImage = await _exportImage();
                                Navigator.pop(context, editedImage);
                              }
                            : null,
                        tooltip: 'Save',
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Pen Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: penColor,
              onColorChanged: _changePenColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset?>> strokes;
  final ui.Image? image;
  final double scaleFactor;
  final Offset imageOffset;
  final Color penColor;

  DrawingPainter(this.strokes, this.image, this.scaleFactor, this.imageOffset,
      this.penColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      // Translate and scale the canvas to fit the image within the screen
      canvas.translate(imageOffset.dx, imageOffset.dy);
      canvas.scale(scaleFactor, scaleFactor);

      // Draw the image
      final paint = Paint();
      canvas.drawImage(image!, Offset.zero, paint);

      // Draw the strokes
      final drawPaint = Paint()
        ..color = penColor
        ..strokeWidth = 2.0 / scaleFactor
        ..strokeCap = StrokeCap.round;

      for (var stroke in strokes) {
        for (int i = 0; i < stroke.length - 1; i++) {
          if (stroke[i] != null && stroke[i + 1] != null) {
            canvas.drawLine(stroke[i]!, stroke[i + 1]!, drawPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

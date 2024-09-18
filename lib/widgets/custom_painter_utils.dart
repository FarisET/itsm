// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class DrawingPainter extends CustomPainter {
//   final List<Offset?> points;
//   final ui.Image? image;

//   DrawingPainter(this.points, this.image);

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (image != null) {
//       // Draw the image
//       final paint = Paint();
//       canvas.drawImageRect(
//         image!,
//         Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()),
//         Rect.fromLTWH(0, 0, size.width, size.height),
//         paint,
//       );

//       // Draw the points
//       final drawPaint = Paint()
//         ..color = Colors.red
//         ..strokeWidth = 2.0
//         ..strokeCap = StrokeCap.round;

//       for (int i = 0; i < points.length - 1; i++) {
//         if (points[i] != null && points[i + 1] != null) {
//           canvas.drawLine(points[i]!, points[i + 1]!, drawPaint);
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

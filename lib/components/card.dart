import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Function()? onTap;

  CustomCard({
    required this.child,
    this.color = Colors.white,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(12.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: const RoundedRectangleBorder(),
        margin: margin,
        color: color,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final Gradient borderGradient;
  final Gradient backgroundGradient;
  final double borderWidth;
  final double borderRadius;

  const GradientContainer({
    super.key,
    required this.child,
    required this.borderGradient,
    required this.backgroundGradient,
    this.borderWidth = 2.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: borderGradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(borderWidth),
        child: Container(
          width: 370,
          height: 430,
          decoration: BoxDecoration(
            
            gradient: backgroundGradient,
            borderRadius: BorderRadius.circular(borderRadius - 2),
          ),
          child: child,
        ),
      ),
    );
  }
}

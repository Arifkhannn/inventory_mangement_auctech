import 'package:flutter/material.dart';

Route createBookToFadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 300), // fade out speed
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      );

      // Determine whether we're pushing or popping
      if (animation.status == AnimationStatus.forward ||
          animation.status == AnimationStatus.completed) {
        // Push: Page turn
        final angle = (1.0 - curvedAnimation.value) * 3.14;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: child,
        );
      } else {
        // Pop: Fade out
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      }
    },
  );
}

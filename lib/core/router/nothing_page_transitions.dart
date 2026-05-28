import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NothingPageTransitions {
  NothingPageTransitions._();

  static const Cubic _nothingEase = Cubic(0.25, 0.1, 0.25, 1.0);

  static CustomTransitionPage<T> fade<T>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: RepaintBoundary(child: child),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: _nothingEase),
          child: child,
        );
      },
    );
  }
}
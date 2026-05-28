import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NothingPageTransitions {
  NothingPageTransitions._();

  static const Duration _duration = Duration(milliseconds: 250);
  static const Curve _curve = Curves.easeOut;

  static CustomTransitionPage<T> fadeSlide<T>({
    required Widget child,
    required GoRouterState state,
    Offset beginOffset = const Offset(0.0, 0.02),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(parent: animation, curve: _curve);
        final slide = Tween<Offset>(begin: beginOffset, end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: _curve));

        return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
      },
    );
  }
}
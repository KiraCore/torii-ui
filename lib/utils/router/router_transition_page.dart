import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef TransitionBuilderCallback =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    );

/// If [transitionsBuilder] was not passed, no animation will be applied.
class RouterTransitionPage extends CustomTransitionPage {
  RouterTransitionPage({
    super.key,
    required super.child,
    TransitionBuilderCallback? transitionsBuilder,
    Duration? transitionDuration,
  }) : super(
         transitionDuration: transitionDuration ?? Duration.zero,
         transitionsBuilder: transitionsBuilder ?? (context, animation, secondaryAnimation, child) => child,
       );
}

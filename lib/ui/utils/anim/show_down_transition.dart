import 'dart:async';

import 'package:flutter/material.dart';

class SlideDownTransition extends StatefulWidget {
  const SlideDownTransition({
    super.key,
    required this.child,
    this.delay,
    this.duration,
    this.onAnimationCreated,
  });

  final Widget child;
  final int? delay;
  final int? duration;
  final Function(AnimationController animationController)? onAnimationCreated;

  @override
  State<SlideDownTransition> createState() => _SlideDownTransitionState();
}

class _SlideDownTransitionState extends State<SlideDownTransition> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 300));
    widget.onAnimationCreated?.call(_animController);
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, -0.35), end: Offset.zero).animate(curve);
    Timer(Duration(milliseconds: widget.delay ?? 100), () {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

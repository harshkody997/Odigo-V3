import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShakeAnimation extends ConsumerStatefulWidget {
  final Widget child;
  final int? delay;
  final int? duration;
  final double? rotateAngle;
  final bool animate;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.delay,
    this.duration,
    this.rotateAngle,
    this.animate = true,
  });

  @override
  ConsumerState<ShakeAnimation> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<ShakeAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  int milliseconds = 70;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: widget.duration ?? milliseconds), vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reset();
      _controller.addListener(() {
        setState(() {});
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int animateCount = 0;

  startAnimation() {
    while (animateCount < 3) {
      _controller.forward().then((value) {
        _controller.reverse().then((value) {
          startAnimation();
          animateCount++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        animateCount = 0;
        startAnimation();
      },
      child: Transform.rotate(
        angle: 0 + ((0.5 - _controller.value) * (pi / 4)),
        child: widget.child,
      ),
    );
  }
}

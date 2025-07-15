import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContinousBounceAnimation extends ConsumerStatefulWidget {
  final Widget child;
  final int? delay;
  final int? duration;
  final double? transformSize;
  final bool animate;

  const ContinousBounceAnimation({
    super.key,
    required this.child,
    this.delay,
    this.duration,
    this.transformSize,
    this.animate = true,
  });

  @override
  ConsumerState<ContinousBounceAnimation> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<ContinousBounceAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  int milliseconds = 70;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: widget.duration ?? milliseconds), vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reset();
      startAnimation();
      _controller.addListener(() {
        setState(() {});
      });
    });
  }

  startAnimation() {
    _controller.forward(from: _controller.value).then((value) {
      if (widget.animate) {
        _controller.reverse(from: _controller.value).then((value) {
          startAnimation();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 + ((_controller.value / 16) * (1 - (widget.transformSize ?? 0))),
      child: widget.child,
    );
  }
}

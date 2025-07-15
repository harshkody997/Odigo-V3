import 'dart:async';

import 'package:odigov3/ui/utils/anim/animation_extension.dart';
import 'package:flutter/material.dart';

class SlideUpTransition extends StatefulWidget {
  final Widget child;
  final int? delay;
  final Offset? begin;
  final int? duration;
  final bool isFade;
  final Function(AnimationController animationController)? onAnimationCreated;

  const SlideUpTransition({super.key, required this.child, this.delay, this.duration, this.begin, this.onAnimationCreated, this.isFade = true});

  @override
  State<SlideUpTransition> createState() => _SlideUpTransitionState();
}

class _SlideUpTransitionState extends State<SlideUpTransition> with TickerProviderStateMixin {
  AnimationController? _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 300));
    if (_animController != null) {
      widget.onAnimationCreated?.call(_animController!);
      final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController ?? AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 300)));
      _animOffset = Tween<Offset>(begin: widget.begin ?? const Offset(0.0, 0.35), end: Offset.zero).animate(curve);

      if (mounted) {
        Future.delayed(Duration(milliseconds: widget.delay ?? 100), () {
          if (!(_animController?.isDisposed ?? false)) {
            _animController?.forward().orCancel;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animController?.stop(canceled: true);
    _animController?.dispose();
    _animController == null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animController != null
        ? widget.isFade
            ? FadeTransition(
                opacity: _animController!,
                child: SlideTransition(
                  position: _animOffset,
                  child: widget.child,
                ),
              )
            : SlideTransition(
                position: _animOffset,
                child: widget.child,
              )
        : const Offstage();
  }
}

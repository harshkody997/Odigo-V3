import 'dart:async';

import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/anim/animation_extension.dart';

class SlideLeftTransition extends StatefulWidget {
  final Widget child;
  final int? delay;
  final int? duration;
  final bool isFade;
  final Offset? offSet;
  final Function(AnimationController animationController)? onAnimationCreated;

  const SlideLeftTransition({super.key, required this.child, this.delay, this.duration, this.onAnimationCreated, this.isFade = true, this.offSet});

  @override
  State<SlideLeftTransition> createState() => _SlideLeftTransitionState();
}

class _SlideLeftTransitionState extends State<SlideLeftTransition> with TickerProviderStateMixin {
  AnimationController? _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 300));
    if (_animController != null) {
      widget.onAnimationCreated?.call(_animController!);
      final curve = CurvedAnimation(curve: Curves.ease, parent: _animController ?? AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 300)));
      _animOffset = Tween<Offset>(begin: widget.offSet ?? const Offset(0.45, 0.0), end: Offset.zero).animate(curve);

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

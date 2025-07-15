import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class BlurTransition extends StatefulWidget {
  final Widget child;
  final int? delay;
  final Offset? begin;
  final int? duration;

  const BlurTransition({super.key, required this.child, this.delay, this.duration, this.begin});

  @override
  State<BlurTransition> createState() => _BlurTransitionState();
}

class _BlurTransitionState extends State<BlurTransition> with TickerProviderStateMixin {
  AnimationController? _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration ?? 600),
    );
    _animController?.addListener(animationListener);
    _animController?.forward();
  }

  void animationListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _animController?.removeListener(animationListener);
    _animController?.stop(canceled: true);
    _animController?.dispose();
    _animController == null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animController != null
        ? ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10 * (1 - _animController!.value), sigmaY: 10 * (1 - _animController!.value)),
            child: widget.child,
          )
        : const Offstage();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListBounceAnimation extends ConsumerStatefulWidget {
  final Widget child;
  final int? delay;
  final int? duration;
  final Function(AnimationController animationController)? onPopCall;
  final Function()? onTap;
  final Function()? onLongPress;
  final Function()? onDoubleTap;
  final double? transformSize;
  final bool animate;
  final bool doReverseBefore;

  const ListBounceAnimation({
    super.key,
    required this.child,
    this.onPopCall,
    this.delay,
    this.duration,
    this.onTap,
    this.transformSize,
    this.onLongPress,
    this.onDoubleTap,
    this.animate = true,
    this.doReverseBefore = true,
  });

  @override
  ConsumerState<ListBounceAnimation> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<ListBounceAnimation> with TickerProviderStateMixin {
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
      widget.onPopCall?.call(_controller);
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
      child: GestureDetector(
        onLongPressDown: (longPresDown) {
          if (widget.animate) {
            _controller.forward(from: _controller.value);
          }
        },
        onLongPressUp: () {
          if (widget.animate) {
            _controller.reverse(from: _controller.value);
          }
        },
        onLongPressCancel: () {
          if (widget.animate) {
            _controller.reverse(from: _controller.value);
          }
        },
        onTapCancel: () {
          if (widget.animate) {
            _controller.reverse(from: _controller.value);
          }
        },
        onLongPress: widget.onLongPress,
        onDoubleTap: widget.onDoubleTap,
        onTap: () {
          if (widget.animate) {
            if (widget.onTap != null) {
              _controller.forward(from: _controller.value).then((value) {
                HapticFeedback.heavyImpact();
                if (widget.doReverseBefore) {
                  _controller.reverse(from: _controller.value);
                  Future.delayed(Duration(milliseconds: (widget.duration ?? 50) - 20), () {
                    widget.onTap?.call();
                  });
                } else {
                  widget.onTap?.call();
                  _controller.reverse(from: _controller.value);
                }
              });
            }
          }
        },
        child: widget.child,
      ),
    );
  }
}

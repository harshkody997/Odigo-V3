import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoverAware extends StatefulWidget {
  final Widget child;
  final bool allowHover;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;

  const HoverAware({super.key, required this.child, required this.allowHover, this.onEnter, this.onExit});

  @override
  State<HoverAware> createState() => _HoverAwareState();
}

class _HoverAwareState extends State<HoverAware> {
  @override
  Widget build(BuildContext context) {
    return widget.allowHover ? MouseRegion(child: widget.child, onEnter: widget.onEnter, onExit: widget.onExit, opaque: false) : widget.child;
  }
}

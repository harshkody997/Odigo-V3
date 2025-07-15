import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class CommonOverlayWidget extends StatefulWidget {
  final Widget child;
  final Widget overlayChild;

  const CommonOverlayWidget({
    super.key,
    required this.child,
    required this.overlayChild,
  });

  @override
  State<CommonOverlayWidget> createState() => _CommonOverlayWidgetState();
}

class _CommonOverlayWidgetState extends State<CommonOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          _showOverlay();
        },
        child: widget.child,
      ),
    );
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showOverlay() {
    _removeOverlay();
    if (!mounted) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final double gapX = context.width * 0.01;
    final double gapY = context.height * 0.01;
    final double overlayWidth = context.width * 0.2;
    final double overlayHeight = context.height * 0.3;

    double dx = 0;
    double dy = 0;

    // Horizontal
    if (position.dx + size.width + overlayWidth + gapX <= context.width) {
      dx = gapX;
    } else if (position.dx - overlayWidth - gapX >= 0) {
      dx = -(overlayWidth - size.width) - gapX;
    } else {
      dx = (size.width - overlayWidth) / 2;
    }

    // Vertical
    if (position.dy + size.height + overlayHeight + gapY <= context.height) {
      dy = size.height + gapY;
    } else {
      dy = -(overlayHeight + gapY);
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _removeOverlay();
              FocusScope.of(context).unfocus();
            },
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            width: overlayWidth,
            child: Consumer(
              builder: (context, ref, child) {
                return CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: true,
                  offset: Offset(dx, dy),
                  child: Material(
                    color: AppColors.transparent,
                    elevation: 10,
                    child: widget.overlayChild,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void didChangeDependencies() {
    _removeOverlay();
    super.didChangeDependencies();
  }
}

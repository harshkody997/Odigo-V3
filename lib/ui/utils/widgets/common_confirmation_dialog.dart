import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonConfirmationOverlayWidget extends StatefulWidget {
  final String title;
  final String description;
  final Function(bool) onButtonTap;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final Widget child;
  final bool isMobile;

  const CommonConfirmationOverlayWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onButtonTap,
    this.positiveButtonText,
    this.negativeButtonText,
    required this.child,
    this.isMobile = false,
  });

  @override
  State<CommonConfirmationOverlayWidget> createState() => _CommonConfirmationOverlayWidgetState();
}

class _CommonConfirmationOverlayWidgetState extends State<CommonConfirmationOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          if (widget.isMobile) {
            showDialog(
              context: context,
              builder: (context) => CommonConfirmationDialogMobile(
                title: widget.title,
                description: widget.description,
                positiveButtonText: widget.positiveButtonText,
                negativeButtonText: widget.negativeButtonText,
                onButtonTap: widget.onButtonTap,
              ),
            );
          } else {
            _showOverlay();
          }
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
                    child: CommonConfirmationDialog(
                      title: widget.title,
                      description: widget.description,
                      onButtonTap: (isPositive) {
                        _removeOverlay();
                        widget.onButtonTap.call(isPositive);
                      },
                      negativeButtonText: widget.negativeButtonText,
                      positiveButtonText: widget.positiveButtonText,
                      height: overlayHeight,
                    ),
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

class CommonConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function(bool) onButtonTap;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final double height;

  const CommonConfirmationDialog({super.key, required this.title, required this.description, required this.onButtonTap, this.positiveButtonText, this.negativeButtonText, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.clrE4E4E7, width: context.width * 0.0005),
      ),
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.height * 0.03),
          CommonText(
            title: title,
            style: TextStyles.bold.copyWith(color: AppColors.black, fontSize: 18),
            maxLines: 10,
            textAlign: TextAlign.center,
          ).paddingOnly(bottom: context.height * 0.02, left: context.width * 0.02, right: context.width * 0.02),
          CommonText(
            title: description,
            style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
            maxLines: 10,
            textAlign: TextAlign.center,
          ).paddingOnly(bottom: context.height * 0.05, left: context.width * 0.02, right: context.width * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
            child: Row(
              children: [
                SizedBox(width: context.width * 0.01),
                Expanded(
                  child: CommonButton(
                    height: context.height * 0.05,
                    buttonText: (negativeButtonText ?? LocaleKeys.keyNo.localized).toUpperCase(),
                    backgroundColor: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    borderColor: AppColors.black,
                    buttonTextStyle: TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                    onTap: () {
                      onButtonTap.call(false);
                    },
                  ),
                ),
                SizedBox(width: context.width * 0.02),
                Expanded(
                  child: CommonButton(
                    height: context.height * 0.05,
                    buttonText: (positiveButtonText ?? LocaleKeys.keyYes.localized).toUpperCase(),
                    backgroundColor: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    buttonTextStyle: TextStyles.semiBold.copyWith(color: AppColors.white, fontSize: 12),
                    onTap: () {
                      onButtonTap.call(true);
                    },
                  ),
                ),
                SizedBox(width: context.width * 0.01),
              ],
            ),
          ),
          SizedBox(height: context.height * 0.02),
        ],
      ),
    );
  }
}

class CommonConfirmationDialogMobile extends StatelessWidget {
  final String title;
  final String description;
  final double? width;
  final Function(bool) onButtonTap;
  final String? positiveButtonText;
  final String? negativeButtonText;

  const CommonConfirmationDialogMobile({super.key, required this.title, required this.description, required this.onButtonTap, this.positiveButtonText, this.negativeButtonText, this.width});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.clrE4E4E7, width: context.width * 0.0005),
        ),
        height: context.height * 0.3,
        width: width ?? context.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.height * 0.03),
            CommonText(
              title: title,
              style: TextStyles.bold.copyWith(color: AppColors.black, fontSize: 24),
              maxLines: 10,
              textAlign: TextAlign.center,
            ).paddingOnly(bottom: context.height * 0.02, left: context.width * 0.02, right: context.width * 0.02),
            CommonText(
              title: description,
              style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
              maxLines: 10,
              textAlign: TextAlign.center,
            ).paddingOnly(bottom: context.height * 0.05, left: context.width * 0.02, right: context.width * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
              child: Row(
                children: [
                  SizedBox(width: context.width * 0.01),
                  Expanded(
                    child: CommonButton(
                      height: context.height * 0.06,
                      buttonText: (negativeButtonText ?? LocaleKeys.keyNo.localized).toUpperCase(),
                      backgroundColor: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      borderColor: AppColors.black,
                      buttonTextStyle: TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                      onTap: () {
                        Navigator.pop(context);
                        onButtonTap.call(false);
                      },
                    ),
                  ),
                  SizedBox(width: context.width * 0.02),
                  Expanded(
                    child: CommonButton(
                      height: context.height * 0.06,
                      buttonText: (positiveButtonText ?? LocaleKeys.keyYes.localized).toUpperCase(),
                      backgroundColor: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      buttonTextStyle: TextStyles.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                      onTap: () {
                        Navigator.pop(context);
                        onButtonTap.call(true);
                      },
                    ),
                  ),
                  SizedBox(width: context.width * 0.01),
                ],
              ),
            ),
            SizedBox(height: context.height * 0.02),
          ],
        ),
      ),
    );
  }
}

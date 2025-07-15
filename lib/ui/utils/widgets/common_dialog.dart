import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

/// show comm widget web dialog
showCommonWebDialog({
  required BuildContext context,
  required Widget dialogBody,
  double? width,
  bool? barrierDismissible,
  double? height,
  GlobalKey? keyBadge,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (context) {
      return ShowDialog(
        height: height,
        width: width,
        dialogBody: dialogBody,
        key_: keyBadge!,
      );
    },
  );
}

class ShowDialog extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget dialogBody;
  final Key key_;
  const ShowDialog({
    super.key,
    required this.height,
    required this.width,
    required this.dialogBody,
    required this.key_,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key_,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(9),
        ),
        width: (context.width * (width ?? 1)),
        height: height != null ? (context.height * (height ?? 1)) : null,
        child: dialogBody,
      ),
    );
  }
}

/// show comm widget web dialog
showCommonDetailDialog({
  required BuildContext context,
  required Widget dialogBody,
  double? width,
  bool? barrierDismissible = true,
  double? height,
  GlobalKey? keyBadge,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return ShowDetailDialog(
        height: height,
        width: width,
        dialogBody: dialogBody,
        key_: keyBadge!,
      );
    },
  );
}

class ShowDetailDialog extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget dialogBody;
  final Key key_;
  const ShowDetailDialog({
    super.key,
    required this.height,
    required this.width,
    required this.dialogBody,
    required this.key_,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: key_,
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: AppColors.transparent,
                  )
              )),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(borderRadius??0),
              ),
              width: (context.width * (width ?? 1)),
              height: height != null ? (context.height * (height ?? 1)) : null,
              child: dialogBody,
            ),
          ),
        ],
      ),
    );
  }
}



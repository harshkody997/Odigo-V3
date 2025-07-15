import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class UploadFileWidget extends ConsumerWidget {
  const UploadFileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deployWatch = ref.watch(deploymentController);
    return (deployWatch.selectedFile != null)
    /// To Show Selected Files
        ? Container(
      padding: EdgeInsets.all(context.height * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.clrE7EAEE),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: context.width * 0.02),

          /// Name & Size Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonText(title: deployWatch.documentName ?? '', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                CommonText(title: deployWatch.documentSize ?? '', clrFont: AppColors.clr7C7474, fontSize: 12, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),

          /// Remove Button
          InkWell(
            onTap: () {
              deployWatch.removeFile();
            },
            child: CommonSVG(strIcon: Assets.svgs.svgClearSearch.path),
          ).paddingOnly(right: 8),
        ],
      ),
    )
    /// to select file
        : Column(
      children: [
        /// Document Upload Section
        InkWell(
          onTap: () async {
            final result = await deployWatch.pickFile(context);
            if (result != null) {
              context.showSnackBar(result);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Document Upload file
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: context.height * 0.07,
                        width: context.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: deployWatch.isFileErrorVisible ? AppColors.red : AppColors.clrE7EAEE),
                          borderRadius: BorderRadius.only(topRight: Radius.zero, bottomRight: Radius.zero, topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                        ),
                        child: CommonText(
                          title: LocaleKeys.keySelectAFileOrDragAndDrop.localized,
                          style: TextStyles.medium.copyWith(color: AppColors.clr7C7474, fontSize: 14),
                        ).alignAtCenterLeft().paddingOnly(left: 10),
                      ),
                    ),
                     Container(
                        height: context.height * 0.07,
                        width: context.width * 0.16,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.whiteEAEAEA,
                          borderRadius: BorderRadius.only(topLeft: Radius.zero, bottomLeft: Radius.zero, topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                          border: Border.all(color: AppColors.clrE7EAEE),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonSVG(height: context.height * 0.02, strIcon: Assets.svgs.svgUploadImage.path),
                            SizedBox(width: 10),
                            CommonText(
                              title: LocaleKeys.keyUploadApk.localized,
                              style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                  ],
                ),
              ),
            ],
          ),
        ),

        /// Error Text
        Visibility(
          visible: deployWatch.isFileErrorVisible,
          child: CommonText(
            title: LocaleKeys.keyFileRequired.localized,
            style: TextStyles.medium.copyWith(color: AppColors.red),
          ).alignAtCenterLeft().paddingOnly(top: 5, left: 15),
        ),
      ],
    );
  }
}

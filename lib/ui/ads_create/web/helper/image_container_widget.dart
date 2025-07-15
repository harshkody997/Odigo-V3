import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';
import 'package:path/path.dart' as path;

class ImageContainerWidget extends ConsumerStatefulWidget {
  const ImageContainerWidget({super.key});

  @override
  ConsumerState<ImageContainerWidget> createState() => _ImageContainerWidgetState();
}

class _ImageContainerWidgetState extends ConsumerState<ImageContainerWidget> {
  late DropzoneViewController controller;

  @override
  Widget build(BuildContext context) {
    final createAdWatch = ref.watch(createAdsController);
    return Column(
      children: [
        if (createAdWatch.listImages != [])
          /// To Show Selected Images
          ...List.generate(createAdWatch.listImages.length, (index) {
            final item = createAdWatch.listImages[index];
            return Container(
              padding: EdgeInsets.all(context.height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.clrE7EAEE),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (item.selectedData != null)
                      ? Image.memory(
                          item.selectedData!,
                          width: context.height * 0.08,
                          height: context.height * 0.08,
                          fit: BoxFit.cover,
                        ).paddingAll(4)
                      : Offstage(),

                  SizedBox(width: context.width * 0.02),

                  /// Name & Size Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CommonText(title: item.documentName ?? '', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                        CommonText(
                          title: item.documentSize ?? '',
                          clrFont: AppColors.clr7C7474,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  /// Remove Button
                  InkWell(
                    onTap: () {
                      if (createAdWatch.tappedIndex != index) {
                        createAdWatch.updateViewerData(item, index);
                      } else {
                        createAdWatch.updateViewerData(null, -1);
                      }
                    },
                    child: CommonSVG(strIcon: createAdWatch.tappedIndex == index ? Assets.svgs.svgHidePasswordSvg_.keyName : Assets.svgs.svgShowPasswordSvg_.keyName),
                  ).paddingOnly(right: 8),
                  InkWell(
                    onTap: () {
                      createAdWatch.removeImage(index);
                      if(createAdWatch.listImages.isEmpty){
                        createAdWatch.addTagNameController.clear();
                      }
                      createAdWatch.updateViewerData(null, -1);
                      createAdWatch.changeImageErrorVisible(true);
                    },
                    child: CommonSVG(strIcon: Assets.svgs.svgClearSearch.path),
                  ).paddingOnly(right: 8),
                ],
              ),
            ).paddingSymmetric(vertical: context.height * 0.01);
          }),

        SizedBox(height: context.height * 0.024),

        /// to select image
        if (createAdWatch.listImages.length < 2)
          Column(
            children: [
              /// Document Upload Section
              InkWell(
                onTap: () async {
                  final result = await createAdWatch.pickImage(context);
                  if (result != null) {
                    context.showSnackBar(result);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Document Upload Image
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: context.height * 0.07,
                                  child: DropzoneView(
                                    onCreated: (ctrl) => controller = ctrl,
                                    onDropFile: _handleDragAndDrop,
                                  ),
                                ),
                                Container(
                                  height: context.height * 0.07,
                                  width: context.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: createAdWatch.isImageErrorVisible ? AppColors.red : AppColors.clrE7EAEE),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.zero,
                                      bottomRight: Radius.zero,
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                    ),
                                  ),
                                  child: CommonText(
                                    title: LocaleKeys.keySelectAFileOrDragAndDrop.localized,
                                    style: TextStyles.medium.copyWith(color: AppColors.clr7C7474, fontSize: 14),
                                  ).alignAtCenterLeft().paddingOnly(left: 10),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: context.height * 0.07,
                            width: context.width * 0.16,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: AppColors.whiteEAEAEA,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                bottomLeft: Radius.zero,
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                              border: Border.all(color: AppColors.clrE7EAEE),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonSVG(height: context.height * 0.02, strIcon: Assets.svgs.svgUploadImage.path),
                                SizedBox(width: 10),
                                CommonText(
                                  title: LocaleKeys.keyUploadImage.localized,
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
                visible: createAdWatch.isImageErrorVisible,
                child: CommonText(
                  title: LocaleKeys.keyImageShouldBeRequired.localized,
                  style: TextStyles.medium.copyWith(color: AppColors.red),
                ).alignAtCenterLeft().paddingOnly(top: 5, left: 15),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _handleDragAndDrop(dynamic event) async {
    final createAdWatch = ref.watch(createAdsController);
    final name = await controller.getFilename(event);
    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileData(event);
    final size = await controller.getFileSize(event);

    if (mime.startsWith('image/')) {
      /// check drag and drop files allowed only image
      final extension = path.extension(name).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].contains(extension)) {
        /// allowed only this extension
        createAdWatch.addTagNameController.text = name;
        createAdWatch.selectedDocumentData = bytes;
        createAdWatch.documentName = name;
        createAdWatch.documentSize = size.toString();

        createAdWatch.listImages.add(
          DocumentData(
            selectedData: bytes,
            documentSize: size.toString(),
            documentName: name,
            fileType: FileType.image,
          ),
        );
        createAdWatch.notifyListeners();
      } else {
        showToast(context: context, isSuccess: false, message: LocaleKeys.keyOnlyAllowedMessage.localized, showAtBottom: true);
      }
    } else {
      showToast(context: context, isSuccess: false, message: LocaleKeys.keyOnlyAnImageIsAllowed.localized, showAtBottom: true);
    }
  }
}

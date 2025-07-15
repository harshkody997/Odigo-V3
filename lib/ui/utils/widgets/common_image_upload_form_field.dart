import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';
import 'package:path/path.dart' as path;


class CommonImageUploadFormField extends ConsumerStatefulWidget {
  final Function(Uint8List) onImageSelected;
  final Function()? onImageRemoved;
  final Uint8List? selectedImage;
  final String? cacheImage;
  final String? labelText;

  const CommonImageUploadFormField( {super.key, required this.onImageSelected, this.selectedImage, this.onImageRemoved, this.cacheImage,this.labelText});

  @override
  ConsumerState createState() => _CommonImageUploadFormFieldState();
}

class _CommonImageUploadFormFieldState extends ConsumerState<CommonImageUploadFormField> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late DropzoneViewController controller;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setInitialImageName();
    });

    focusNode.addListener(() {
      if (mounted) setState(() {});
    });

    super.initState();

  }

  @override
  void didUpdateWidget(covariant CommonImageUploadFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cacheImage != widget.cacheImage) {
      _setInitialImageName();
    }
  }

  void _setInitialImageName() {
    if (widget.cacheImage != null) {
      final name = getImageNameFromUrl(widget.cacheImage!);

      /// Schedule the controller update after current build completes
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && textEditingController.text != name) {
          textEditingController.text = name;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.cacheImage == null ? SizedBox(
          height : context.height * 0.07,
          child: DropzoneView(
            onCreated: (ctrl) => controller = ctrl,
            onDropFile: _handleDragAndDrop,
          ),
        ) : Offstage(),
        CommonInputFormField(
          focusNode: focusNode,
          giveConstraints: false,/// manage image type name
          labelText: (textEditingController.text.isNotEmpty || widget.cacheImage != null || focusNode.hasFocus) ? widget.labelText : LocaleKeys.keySelectAFileOrDragAndDrop.localized,
          textEditingController: textEditingController,
          hintText: LocaleKeys.keySelectAFileOrDragAndDrop.localized,
          prefixWidget: widget.selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(widget.selectedImage!, height: context.height * 0.04, width: context.height * 0.04, fit: BoxFit.cover),
                ).paddingOnly(left: context.width * 0.005,top: context.height * 0.005)
              : widget.cacheImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CacheImage(imageURL: widget.cacheImage!, height: context.height * 0.05, width: context.height * 0.05),
                ).paddingOnly(left: context.width * 0.005,top: context.height * 0.005)
              : null,
          readOnly: true,
          onTap: () async {
            var res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true, allowMultiple: false,);
            if (res?.xFiles.isNotEmpty ?? false) {
              final file = res?.xFiles.first;
              if(file == null) return;
              final extension = path.extension(file.name).toLowerCase();
              if (['.jpg', '.jpeg', '.png'].contains(extension)) { /// allowed only this extension
                textEditingController.text = res!.xFiles.first.name;
                var bytes = await res.xFiles.first.readAsBytes();
                widget.onImageSelected.call(bytes);
              } else {
                showToast(context: context,isSuccess:false,message:LocaleKeys.keyOnlyAllowedMessage.localized,showAtBottom: true);
              }
            }
          },
          validator: (value) => widget.cacheImage == null ? validateText(value, LocaleKeys.keyImageRequiredValidation.localized) : null,
          suffixWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.selectedImage != null || widget.cacheImage != null) ...{
                InkWell(
                  onTap: () {
                    textEditingController.clear();
                    widget.onImageRemoved?.call();
                  },
                  child: CommonSVG(strIcon: Assets.svgs.svgClearSearch.path),
                ),
                SizedBox(width: context.width * 0.005),
              },
              AbsorbPointer(
                absorbing: widget.selectedImage != null || widget.cacheImage != null,
                child: Opacity(
                  opacity: widget.selectedImage != null || widget.cacheImage != null ? 0.2 : 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          var res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true, allowMultiple: false,);
                          if (res?.xFiles.isNotEmpty ?? false) {
                            final file = res?.xFiles.first;
                            if(file == null) return;
                            final extension = path.extension(file.name).toLowerCase();
                            if (['.jpg', '.jpeg', '.png'].contains(extension)) { /// allowed only this extension
                              textEditingController.text = res!.xFiles.first.name;
                              var bytes = await res.xFiles.first.readAsBytes();
                              widget.onImageSelected.call(bytes);
                            } else {
                              showToast(context: context,isSuccess:false,message:LocaleKeys.keyOnlyAllowedMessage.localized,showAtBottom: true);
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: context.height * 0.021, horizontal: context.width * 0.005),
                          decoration: BoxDecoration(
                            color: AppColors.clrF4F5F7,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CommonSVG(strIcon: Assets.svgs.svgUploadImage.path),
                              SizedBox(width: context.width * 0.005),
                              CommonText(title: LocaleKeys.keyUploadImage.localized),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDragAndDrop(dynamic event) async {
    final name = await controller.getFilename(event);
    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileData(event);

    if (mime.startsWith('image/')) { /// check drag and drop files allowed only image
      final extension = path.extension(name).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].contains(extension)) { /// allowed only this extension
      textEditingController.text = name;
      widget.onImageSelected.call(bytes);
      }else{
        showToast(context: context,isSuccess:false,message:LocaleKeys.keyOnlyAllowedMessage.localized,showAtBottom: true);
      }
    } else {
      showToast(context: context,isSuccess:false,message:LocaleKeys.keyOnlyAnImageIsAllowed.localized,showAtBottom: true);
    }
  }
}

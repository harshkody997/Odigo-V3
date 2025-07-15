import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_image_upload_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class UploadDocumentFormWidget extends ConsumerStatefulWidget {
  final String? clientUuid;
  final String? documentUuid;
  const UploadDocumentFormWidget({super.key,this.clientUuid, this.documentUuid});

  @override
  ConsumerState<UploadDocumentFormWidget> createState() => _UploadDocumentFormWidgetState();
}

class _UploadDocumentFormWidgetState extends ConsumerState<UploadDocumentFormWidget> {

  @override
  void initState() {
    final addUpdateClientRead = ref.read(addUpdateClientController);
    addUpdateClientRead.clearDocumentFormData();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp){
      if(widget.documentUuid != null){
        addUpdateClientRead.setPrefillDocument(context,widget.documentUuid,widget.clientUuid);
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final addUpdateClientWatch = ref.watch(addUpdateClientController);
    return Form(
      key: addUpdateClientWatch.addUpdateClientFromKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Document Name Input
          CommonInputFormField(
            focusNode: addUpdateClientWatch.documentNameFocusNode,
            textEditingController: addUpdateClientWatch.documentNameController,
            hintText: LocaleKeys.keyEnterDocumentTitle.localized,
            validator: (value) {
              if (addUpdateClientWatch.selectedImages.isEmpty) {
                return validateText(value, LocaleKeys.keyPleaseEnterDocumentName.localized);
              }
              return null;
            },
            textInputType: TextInputType.name,
            maxLength: 100,
          ),
          SizedBox(height: 25),
          CommonImageUploadFormField(
              selectedImage:addUpdateClientWatch.selectedImages.firstOrNull,
              cacheImage:addUpdateClientWatch.documentData?.url,
              onImageSelected: (image){
                addUpdateClientWatch.updateDocumentImage(image);
              },
              onImageRemoved: (){
                if(widget.documentUuid != null){
                  addUpdateClientWatch.documentData?.url = null;
                  addUpdateClientWatch.notifyListeners();
                }
                addUpdateClientWatch.selectedImages.clear();
                addUpdateClientWatch.documentNames.clear();
                addUpdateClientWatch.notifyListeners();
              },
          ),
          SizedBox(height: 25),
          CommonButton(
            onTap: () async {

              bool? isValid = addUpdateClientWatch.addUpdateClientFromKey.currentState?.validate();
              if(isValid == true){
                if(widget.documentUuid == null){ /// add document
                  addUpdateClientWatch.updateDocumentImageName();
                  await addUpdateClientWatch.uploadDocumentImageApi(context, uuid: widget.clientUuid??'',);
                  if(addUpdateClientWatch.uploadDocumentImageState.success?.status == ApiEndPoints.apiStatus_200){
                    selectDocumentTabApiCallAndPop(ref);
                  }
                }else{ /// update document
                  addUpdateClientWatch.updateEditDocumentImage();
                  addUpdateClientWatch.updateEditDocumentImageName();
                  await addUpdateClientWatch.updateDocumentImageApi(context, uuid: widget.documentUuid??'',nameOfDocument: addUpdateClientWatch.documentNameController.text);
                  if(addUpdateClientWatch.uploadDocumentImageState.success?.status == ApiEndPoints.apiStatus_200){
                    selectDocumentTabApiCallAndPop(ref);
                  }
                }
              }
            },
            width: 164,
            isLoading: addUpdateClientWatch.isDocumentUploadLoading,
            buttonText: LocaleKeys.keySubmit.localized,
          )
        ],
      ),
    );
  }
  
  selectDocumentTabApiCallAndPop(WidgetRef ref){
    ref.read(clientDetailsController).updateSelectedTab(3);
    ref.read(addUpdateClientController).getDocumentImageByUuidApi(context, widget.clientUuid??'');
    ref.read(navigationStackController).pop();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/category/add_edit_category_controller.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_image_upload_form_field.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class AddEditCategoryFormWidget extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditCategoryFormWidget({super.key,this.isEdit, this.uuid,});

  @override
  ConsumerState<AddEditCategoryFormWidget> createState() => _AddEditCategoryFormWidgetState();
}

class _AddEditCategoryFormWidgetState extends ConsumerState<AddEditCategoryFormWidget> {
  @override
  Widget build(BuildContext context) {
    final addEditStateWatch = ref.watch(addEditCategoryController);
    return AbsorbPointer(
      absorbing: addEditStateWatch.isLoading || addEditStateWatch.categoryDetailsState.isLoading,
      child: Form(
        key: addEditStateWatch.formKey,
        child: Column(
          children: [
            /// category textField
            DynamicLangFormManager.instance.dynamicWidget(
                addEditStateWatch.listForTextField,
                DynamicFormEnum.CATEGORY,
                onFieldSubmitted: ((value){

                })
            ),

            /// upload category image textField
            CommonImageUploadFormField(
              labelText: LocaleKeys.keyCategoryImage.localized,
              selectedImage: addEditStateWatch.categoryImage,
              cacheImage: addEditStateWatch.categoryDetailsState.success?.data?.categoryImageUrl,
              onImageSelected: (image) {
                addEditStateWatch.categoryImage = image;
                addEditStateWatch.notifyListeners();
              },
              onImageRemoved: () {
                addEditStateWatch.categoryImage = null;
                addEditStateWatch.categoryDetailsState.success?.data?.categoryImageUrl = null;
                addEditStateWatch.notifyListeners();
              },
            ).paddingOnly(top: context.height * 0.025),

            /// save continue & back buttons
            Row(
              children: [
                /// save continue button
                CommonButton(
                  width: context.width * 0.1,
                  borderRadius: BorderRadius.circular(8),
                  fontSize: 14,
                  buttonText: LocaleKeys.keySave.localized,
                  isLoading: addEditStateWatch.isLoading,
                  onTap: (){
                    bool? isValid = addEditStateWatch.formKey.currentState?.validate();
                    if(isValid == true){
                      if(widget.isEdit == true){
                        addEditStateWatch.editCategoryAPI(context,widget.uuid).then((value){
                          if(value.success?.status == ApiEndPoints.apiStatus_200){
                            uploadImageApiCategoryListApiAndBack(ref,widget.uuid);
                          }
                        });
                      }else{
                        addEditStateWatch.addCategoryAPI(context).then((value){
                          if(value.success?.status == ApiEndPoints.apiStatus_200){
                            uploadImageApiCategoryListApiAndBack(ref,value.success?.data?.uuid);
                          }
                        });
                      }
                    }
                  },
                ).paddingOnly(right: context.width * 0.01),

                /// back button
                CommonButton(
                  width: context.width * 0.1,
                  borderRadius: BorderRadius.circular(8),
                  fontSize: 14,
                  buttonText: LocaleKeys.keyBack.localized,
                  borderColor: AppColors.black,
                  backgroundColor: AppColors.transparent,
                  buttonTextColor: AppColors.clr787575,
                  onTap: () => ref.read(navigationStackController).pop(),
                ),
              ],
            ).paddingOnly(top: context.height * 0.025),
          ],
        ),
      ),
    );
  }

  void categoryListApiCallAndPop(WidgetRef ref) {
    ref.read(categoryListController).clearCategoryList();
    ref.read(categoryListController).getCategoryListAPI(context);
    ref.read(navigationStackController).pop();
  }

  void uploadImageApiCategoryListApiAndBack(WidgetRef ref,String? uuid) {
    final addEditStateWatch = ref.watch(addEditCategoryController);
    if(addEditStateWatch.categoryImage != null){ /// image not null then upload category image api call
      addEditStateWatch.uploadCategoryImageApi(context,uuid??'').then((imageValue){
        if(imageValue.success?.status == ApiEndPoints.apiStatus_200){
          categoryListApiCallAndPop(ref);
        }
      });
    }else{
      categoryListApiCallAndPop(ref);
    }
  }
}

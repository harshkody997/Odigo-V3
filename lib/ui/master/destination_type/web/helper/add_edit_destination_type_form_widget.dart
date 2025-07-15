import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/destination_type/add_edit_destination_type_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
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
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class AddEditDestinationTypeFormWidget extends ConsumerStatefulWidget {
  final String? uuid;
  const AddEditDestinationTypeFormWidget({super.key,this.uuid});

  @override
  ConsumerState<AddEditDestinationTypeFormWidget> createState() => _AddEditDestinationTypeWidgetState();
}

class _AddEditDestinationTypeWidgetState extends ConsumerState<AddEditDestinationTypeFormWidget> {

  @override
  Widget build(BuildContext context) {
    final addEditDestinationTypeWatch = ref.watch(addEditDestinationTypeController);
    return AbsorbPointer(
      absorbing: addEditDestinationTypeWatch.isLoading || addEditDestinationTypeWatch.destinationTypeDetailsState.isLoading,
      child: Form(
        key: addEditDestinationTypeWatch.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            /// destination type textFields
            DynamicLangFormManager.instance.dynamicWidget(
                addEditDestinationTypeWatch.listForTextField,
                DynamicFormEnum.DESTINATION_TYPE,
                onFieldSubmitted: (value) => checkValidationAndApiCall(ref)
            ),

            /// save continue & back buttons
            Row(
              children: [
                /// save continue button
                CommonButton(
                  width: context.width * 0.1,
                  borderRadius: BorderRadius.circular(8),
                  fontSize: 14,
                  buttonText: LocaleKeys.keySave.localized,
                  isLoading: addEditDestinationTypeWatch.isLoading,
                  onTap: () => checkValidationAndApiCall(ref),
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
            ).paddingOnly(top: context.height * 0.024),

          ],
        ),
      ),
    );
  }

  void checkValidationAndApiCall(WidgetRef ref) {
    final addEditDestinationTypeWatch = ref.watch(addEditDestinationTypeController);
    bool? isValid = addEditDestinationTypeWatch.formKey.currentState?.validate();
    if(isValid == true){
      if(widget.uuid != null){
        /// edit destination type api
        addEditDestinationTypeWatch.editDestinationTypeAPI(context,widget.uuid).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            callDestinationTypeListApiAndPop(ref);
          }
        });
      }else{
        /// add destination type api
        addEditDestinationTypeWatch.addDestinationTypeAPI(context).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            callDestinationTypeListApiAndPop(ref);
          }
        });
      }
    }
  }

  /// destination type list api call and back
  void callDestinationTypeListApiAndPop(WidgetRef ref){
    ref.read(destinationTypeListController).clearDestinationTypeList();
    ref.read(destinationTypeListController).getDestinationTypeListAPI(context);
    ref.read(navigationStackController).pop();
  }
}

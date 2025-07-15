import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

class AddEditClientsBottomButtonWidget extends ConsumerWidget {
  final String? clientUuid;
  final Function? popCallBack;

  const AddEditClientsBottomButtonWidget({super.key, this.clientUuid, this.popCallBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addUpdateClientWatch = ref.watch(addUpdateClientController);
    return Row(
      children: [
        /// Bottom Save Button
        CommonButton(
          height: 50,
          width: 150,
          buttonText: LocaleKeys.keySave.localized,
          isLoading: addUpdateClientWatch.addNewClientApiState.isLoading || addUpdateClientWatch.updateClientApiState.isLoading || addUpdateClientWatch.uploadDocumentImageState.isLoading,
          onTap: () async {
            checkValidateAndApiCallForClient(context, ref);
          },
        ),
        SizedBox(width: 20),

        /// Back Button
        CommonButton(
          height: 50,
          width: 150,
          buttonText: LocaleKeys.keyBack.localized,
          borderColor: AppColors.clr9E9E9E,
          backgroundColor: AppColors.clrF4F5F7,
          buttonTextColor: AppColors.clr787575,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  /// Check Validation And API Call
  void checkValidateAndApiCallForClient(BuildContext context, WidgetRef ref) async {
    final addClientWatch = ref.watch(addUpdateClientController);
    bool isValid = addClientWatch.addUpdateClientFromKey.currentState?.validate() ?? false;

    if (isValid) {
      // Check image validation
      if (addClientWatch.selectedImages.isEmpty && (clientUuid?.isEmpty ?? true)) {
        addClientWatch.changeImageErrorVisible(true);
        return; // Stop further execution
      } else {
        addClientWatch.changeImageErrorVisible(false);
      }

      if (clientUuid != null && clientUuid!.isNotEmpty) {
        // Update client
        await addClientWatch.updateClientApi(context, clientUuid!).then((value) {
          if (addClientWatch.updateClientApiState.success?.status == ApiEndPoints.apiStatus_200) {
            if (addClientWatch.selectedImages.isNotEmpty) {
              addClientWatch.uploadDocumentImageApi(
                context,
                uuid: clientUuid ?? '',
              );
            }
            popCallBack?.call();
            ref.watch(navigationStackController).pop();
            ref.read(clientListController).getClientApi(context);
          }
        });
      } else {
        // Add new client
        await addClientWatch.addClientApi(context, ref).then((value) async {
          if (addClientWatch.addNewClientApiState.success?.status == ApiEndPoints.apiStatus_200) {
            await addClientWatch.uploadDocumentImageApi(
              context,
              uuid: addClientWatch.addNewClientApiState.success?.data?.uuid ?? '',
            );
            popCallBack?.call();
            addClientWatch.disposeController(isNotify: true);
            ref.watch(navigationStackController).pop();
            ref.read(clientListController).getClientApi(context);
          }
        });
      }
    }
  }
}

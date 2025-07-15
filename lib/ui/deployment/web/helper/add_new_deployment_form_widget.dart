import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/deployment/web/helper/upload_file_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';

class AddNewDeploymentFormWidget extends ConsumerStatefulWidget {
  const AddNewDeploymentFormWidget({super.key});

  @override
  ConsumerState<AddNewDeploymentFormWidget> createState() =>
      _AddNewDeploymentFormWidgetState();
}

class _AddNewDeploymentFormWidgetState
    extends ConsumerState<AddNewDeploymentFormWidget> {
  ///Build
  @override
  Widget build(BuildContext context) {
    final destinationWatch = ref.watch(destinationController);
    final deploymentWatch = ref.watch(deploymentController);
    final RegExp versionRegExp = RegExp(r'^\d+(\.\d+){0,2}(\+\d+)?$');

    return destinationWatch.destinationListState.isLoading
        ? SizedBox(height: context.height * 0.25, child: CommonAnimLoader())
        : Form(
            key: deploymentWatch.deployFormKey,
            child: Column(
              children: [
                ///Version name  and url  field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Version name field.
                    Flexible(
                      child: CommonInputFormField(
                        textEditingController:
                            deploymentWatch.versionNameController,
                        hintText: LocaleKeys.keyVersionName.localized,
                        textInputType: TextInputType.text,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ), // Allow only numbers and dots
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.keyVersionRequired.localized;
                          }
                          if (!versionRegExp.hasMatch(value)) {
                            return LocaleKeys.keyInvalidVersionFormat.localized;
                          }
                          return null;
                        },
                        maxLength: 10,
                        onFieldSubmitted: (value) {
                          deploymentWatch.destinationFocusNode.requestFocus();
                        },
                      ),
                    ),
                    SizedBox(width: 25),

                    ///destination selection dropdown
                    Flexible(
                      child: CommonSearchableDropdown<DestinationData>(
                        textEditingController: deploymentWatch.selectDestinationCtr,
                        hintText: LocaleKeys.keyDestination.localized,
                        passedFocus: deploymentWatch.destinationFocusNode,
                        onSelected: (destination) {
                          deploymentWatch.updateSelectedDestination(destination);
                        },
                        items: ref.watch(destinationController).destinationList,
                        validator: (value) => validateText(
                          value,
                          LocaleKeys.keyDestinationRequired.localized,
                        ),
                        title: (value) {
                          return value.name ?? '';
                        },
                        onFieldSubmitted: (val) {
                        },
                        onScrollListener: () {
                          ref
                              .watch(destinationController)
                              .getDestinationListApi(
                            context,
                            isReset: false,
                            pagination: true,
                          )
                              .then((value) {
                            if (ref
                                .read(destinationController)
                                .destinationListState
                                .success
                                ?.status ==
                                ApiEndPoints.apiStatus_200) {
                              ref.read(searchController).notifyListeners();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.height * 0.02),
                UploadFileWidget(),
              ],
            ),
          );
  }
}

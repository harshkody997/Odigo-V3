import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/upload_document_form_widget.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class UploadDocumentWeb extends ConsumerStatefulWidget {
  final String? clientUuid;
  final String? documentUuid;
  const UploadDocumentWeb({Key? key,this.clientUuid, this.documentUuid}) : super(key: key);

  @override
  ConsumerState<UploadDocumentWeb> createState() => _UploadDocumentWebState();
}

class _UploadDocumentWebState extends ConsumerState<UploadDocumentWeb> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    // final uploadDocumentWatch = ref.read(uploadDocumentController);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ref.watch(addUpdateClientController).getDocumentByUuidState.isLoading
                ? CommonAnimLoader()
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// upload document text
                  CommonText(title: LocaleKeys.keyUploadDocuments.localized,
                      fontWeight: TextStyles.fwSemiBold
                  ).paddingOnly(bottom: 24),

                  /// upload document widget
                  UploadDocumentFormWidget(clientUuid: widget.clientUuid,documentUuid: widget.documentUuid,)
                ],
              ).paddingAll(context.height * 0.025),
            ).paddingAll(context.height * 0.01),
          ),

          ///Back button
          CommonButton(
            width: context.width * 0.11,
            onTap: () {
              ref.read(navigationStackController).pop();
            },
            buttonText: LocaleKeys.keyBack.localized,
            backgroundColor: AppColors.transparent,
            borderColor: AppColors.greyD0D5DD,
            buttonTextStyle: TextStyles.medium.copyWith(
              fontSize: 14,
              color: AppColors.black,
            ),
          ).paddingOnly(top: 20),
        ],
      ),
    );
  }


}

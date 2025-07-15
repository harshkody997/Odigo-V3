import 'package:flutter/cupertino.dart';
import 'package:odigov3/framework/repository/client/model/response/get_document_by_uuid_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';

class DocumentViewWidget extends StatelessWidget {
  final DocumentData documentData;
  const DocumentViewWidget({super.key, required this.documentData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// document image
        CacheImage(imageURL: documentData.url??'',height: context.height * 0.4,width: context.width * 0.55,contentMode: BoxFit.fill,),
        /// document name
        CommonInputFormField(
            isEnable: false,
            hintText: LocaleKeys.keyDocumentName.localized,
            textEditingController: TextEditingController(text: documentData.name??'')
        ).paddingSymmetric(vertical:context.height * 0.025),
        /// back button
        CommonButton(
          buttonText: LocaleKeys.keyBack.localized,
          onTap: (){
            Navigator.pop(context);
          },
        )
      ],
    ).paddingAll(context.height * 0.036);
  }
}

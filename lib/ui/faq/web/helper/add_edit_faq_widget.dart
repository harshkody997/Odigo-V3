import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/faq/add_edit_faq_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class AddEditFaqWidget extends ConsumerStatefulWidget {
  final String? uuid;
  const AddEditFaqWidget({super.key, this.uuid});

  @override
  ConsumerState<AddEditFaqWidget> createState() => _AddEditFaqWidgetState();
}

class _AddEditFaqWidgetState extends ConsumerState<AddEditFaqWidget> {

  ///Build
  @override
  Widget build(BuildContext context) {
    final addEditFaqWatch = ref.watch(addEditFaqController);
    return Form(
      key: addEditFaqWatch.addEditFaqFormKey,
      child: Column(
        children: [
          DynamicLangFormManager.instance.dynamicWidget(
            addEditFaqWatch.questionTextFieldList,
            DynamicFormEnum.FAQ_QUESTION,
            onFieldSubmitted: (value) {
              addEditFaqWatch.addEditFaqApiCall(context, ref, faqUuid: widget.uuid);
            },
          ),
          SizedBox(height: context.height * 0.02),
          DynamicLangFormManager.instance.dynamicWidget(
            addEditFaqWatch.answerTextFieldList,
            DynamicFormEnum.FAQ_ANSWER,
            onFieldSubmitted: (value) {
              addEditFaqWatch.addEditFaqApiCall(context, ref, faqUuid: widget.uuid);
            },
          ),
        ],
      ),
    );
  }
}

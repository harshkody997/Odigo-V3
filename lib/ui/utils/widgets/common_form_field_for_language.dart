import 'package:flutter/cupertino.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/master/helper/common_form_field_perfix_sufix_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';

class CommonFormFieldForLanguage extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isRTL;
  final String languageName;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool hideSuffix;

  const CommonFormFieldForLanguage({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.validator,
    this.isRTL = false, required this.languageName, this.maxLines, this.minLines, this.maxLength, this.onFieldSubmitted, this.focusNode,
    this.hideSuffix = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: CommonInputFormField(
        textEditingController: textEditingController,
        hintText: hintText,
        // prefixIconConstraints: BoxConstraints(
        //   maxHeight: context.height * 0.07,
        //   maxWidth: context.height * 0.12,
        // ),
        suffixIconConstraints: hideSuffix ? null : BoxConstraints(
          maxHeight: context.height * 0.07,
          // maxWidth: context.height * 0.12,
        ),
        // prefixWidget: isRTL ? null : CommonFormFieldPrefixSuffixWidget(
        //   isRTL: isRTL,
        //   languageName: languageName.capsFirstLetterOfSentence,
        // ),
        suffixWidget: hideSuffix ? null : CommonFormFieldPrefixSuffixWidget(
          isRTL: isRTL,
          languageName: languageName.capsFirstLetterOfSentence,
        ) /*: CommonFormFieldPrefixSuffixWidget(
          isRTL: isRTL,
          languageName: languageName.capsFirstLetterOfSentence,
        )*/,
        hintTextStyle: TextStyles.regular.copyWith(
          color: AppColors.clr7C7474,
        ),
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        validator: validator,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}

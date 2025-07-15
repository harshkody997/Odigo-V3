import 'package:flutter/cupertino.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field_for_language.dart';

class DynamicLangFormManager {
  DynamicLangFormManager._privateConstructor();

  static final DynamicLangFormManager instance =
      DynamicLangFormManager._privateConstructor();

  /// Get Language List Model
  List<LanguageModel> getLanguageListModel({
    List<LanguageModel>? textFieldModel,
  }) {
    /// List
    List<LanguageModel> dynamicListForTextField = [];

    /// Get Language Model From Session
    GetLanguageListResponseModel? model = getLanguageModelFromSession();

    if (model != null) {
      /// Add into local List
      dynamicListForTextField.addAll(model.data ?? []);

      for (var lang in dynamicListForTextField) {
        /// If language uuid is same or not
        final commonLang = textFieldModel?.firstWhere(
          (e) => e.uuid == lang.uuid,
          orElse: () => LanguageModel(
            focusNode: FocusNode(),
            textEditingController: TextEditingController(text: ''),
          ),
        );

        /// If same language then pass Field Value to the TextEditing controller
        lang.textEditingController = TextEditingController(
          text: commonLang?.fieldValue ?? '',
        );
        lang.focusNode = FocusNode();
      }
    }

    /// Return List<LanguageModel>
    return dynamicListForTextField;
  }

  /// Widget Dynamic Forms
  Widget dynamicWidget(
    List<LanguageModel> modelList,
    DynamicFormEnum dynamicEnum, {
        ValueChanged<String>? onFieldSubmitted,
        double? fieldWidth
      }
  ) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double spacing = context.height * 0.025;
              double totalSpacing = spacing;
              double itemWidth = (constraints.maxWidth - totalSpacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(modelList.length, (index) {
                  DynamicFormModel model = getDynamicFormTextField(dynamicEnum);
                  return SizedBox(
                    width: fieldWidth ?? itemWidth,
                    child: CommonFormFieldForLanguage(
                      languageName: modelList[index].name ?? '',
                      isRTL: modelList[index].isRtl ?? false,
                      focusNode: modelList[index].focusNode ?? FocusNode(),
                      textEditingController: modelList[index].textEditingController ?? TextEditingController(),
                      hintText: model.hintText,
                      maxLength: model.maxLength,
                      maxLines: (dynamicEnum == DynamicFormEnum.FAQ_ANSWER) ? 5 : null,
                      hideSuffix: (dynamicEnum == DynamicFormEnum.FAQ_ANSWER),
                      onFieldSubmitted: (value){
                        if (index + 1 < modelList.length) {
                          modelList[index + 1].focusNode?.requestFocus();
                        }

                        /// if last textField call onFieldSubmitted
                        if(index == modelList.length -1){
                          onFieldSubmitted?.call(value);
                        }

                      },
                      validator: (value) {
                        return validateText(value, model.errorText);
                      },
                    ),
                  );
                }),
              );
              // ),
            },
          ),
        ),
      ],
    );
  }
}

/// ===========================
/// USAGE GUIDE
/// ===========================

/// 1. Add this function to your controller
///
/// This function will return a `List<LanguageModel>`
///
/// Example:
///
/// ```dart
/// List<LanguageModel> listForTextField = [];
///
/// void getLanguageListModel(bool? isEdit) {
///   listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
///     textFieldModel: null,
///   );
///   notifyListeners();
/// }
/// ```

/// 2. For edit flow (i.e., when pre-filled values are required),
/// pass your existing language data with `uuid`, `fieldValue`, and `name`.
///
/// Example:
///
/// ```dart
/// List<LanguageModel> languageModel = [
///   LanguageModel(
///     uuid: '8ARK-EVFQ-0Y0R-2GVX-79X0',
///     fieldValue: 'Gujarat1 Arabic',
///     name: 'arabic',
///   ),
///   LanguageModel(
///     uuid: 'E3D7-PGV5-PNF3-B8F1-PHOH',
///     fieldValue: 'Gujarat1 English',
///     name: 'english',
///   ),
/// ];
///
/// listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
///   textFieldModel: languageModel,
/// );
/// ```

/// 3. On the UI side, render the dynamic language form like this:
///
/// ```dart
/// DynamicLangFormManager.instance.dynamicWidget(
///   addEditStateWatch.listForTextField,
///   DynamicForm,
/// );
/// ```

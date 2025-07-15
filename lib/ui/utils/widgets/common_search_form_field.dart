import 'dart:async';
import 'dart:math';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';

class CommonSearchFormField extends StatelessWidget {
  final Function(dynamic text)? onChanged;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? borderWidth;
  final EdgeInsets? padding;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final TextStyle? style;
  final int? maxSearchLength;

  const CommonSearchFormField({
    super.key,
    this.onChanged,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.backgroundColor,
    this.padding,
    this.placeholder,
    this.placeholderStyle,
    this.controller,
    this.focusNode,
    this.onTap,
    this.style,
    this.maxSearchLength,
  });

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    return CommonInputFormField(
        textEditingController: controller?? TextEditingController(),
        hintText: placeholder??'Type to search',
        hintTextStyle: placeholderStyle ?? TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr727272),
        onChanged: (value){
          EasyDebounce.debounce(
              'search-debounce',
              Duration(milliseconds: 500),
                  () => onChanged?.call(value)
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: min(context.height * 0.07,context.height * 0.07) * 0.25),
        borderColor: AppColors.clrEAEAEA,
        backgroundColor: backgroundColor ?? AppColors.white,
        focusNode: focusNode,
        onTap: onTap,
        fieldTextStyle:style,
        textInputFormatter:[
           searchInputFormatter(),
        ],
        maxLength: maxSearchLength??50,
        prefixWidget:const Icon(CupertinoIcons.search).paddingOnly(left: context.width*0.007) ,
        prefixIconConstraints:BoxConstraints(maxHeight: context.height * 0.03, maxWidth: context.height * 0.05) ,
        suffixWidget: controller?.text.isNotEmpty??false? InkWell(
          onTap: (){
            controller?.clear();
            onChanged?.call('');
            AppConstants.hideKeyboard(context);
          },
          child: const Icon(CupertinoIcons.clear_circled_solid)):null,
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          floatingLabelBehavior:FloatingLabelBehavior.never,
    );
  }
}

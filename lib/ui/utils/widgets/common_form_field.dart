import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonInputFormField extends ConsumerStatefulWidget {
  final TextEditingController textEditingController;
  final Function(String)? onSelected;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? placeholderText;
  final TextStyle? placeholderTextStyle;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final double? fieldWidth;
  final double? fieldHeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final TextStyle? fieldTextStyle;
  final ValueChanged<String>? onFieldSubmitted;
  final TextStyle? counterStyle;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final bool? isEnable;
  final bool giveConstraints;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final InputDecoration? inputDecoration;
  final bool? obscureText;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? fontSize;
  final Function(dynamic text)? onChanged;
  final Widget? suffixLabel;
  final Color? cursorColor;
  final bool? enableInteractiveSelection;
  final bool? readOnly;
  final bool? isFilledBorder;
  final Widget? label;
  final String? autoCompleteKey;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextDirection? textDirection;
  final Widget? counterWidget;
  final bool? counterRequired;
  final TextStyle? errorStyle;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final EdgeInsets? contentPadding;

  const CommonInputFormField({
    Key? key,
    required this.textEditingController,
    this.onSelected,
    this.focusNode,
    this.validator,
    this.placeholderText,
    this.placeholderTextStyle,
    this.hintText,
    this.giveConstraints = true,
    this.hintTextStyle,
    this.fieldWidth,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.fieldTextStyle,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputFormatter,
    this.textInputAction,
    this.textInputType,
    this.textCapitalization,
    this.isEnable,
    this.prefixWidget,
    this.suffixWidget,
    this.inputDecoration,
    this.obscureText,
    this.onChanged,
    this.suffixLabel,
    this.cursorColor,
    this.enableInteractiveSelection,
    this.readOnly,
    this.fieldHeight,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.label,
    this.textAlign,
    this.isFilledBorder,
    this.fontSize,
    this.counterStyle,
    this.onFieldSubmitted,
    this.onTap,
    this.autoCompleteKey,
    this.counterRequired,
    this.counterWidget,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.textDirection,
    this.errorStyle,
    this.labelText,
    this.floatingLabelBehavior,
    this.contentPadding,
  }) : super(key: key);

  @override
  ConsumerState<CommonInputFormField> createState() => _CommonInputFormFieldState();
}

class _CommonInputFormFieldState extends ConsumerState<CommonInputFormField> {
  @override
  Widget build(BuildContext context) {
    final defaultHeight = context.height * 0.07;
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.fieldWidth ?? double.infinity,
        height: widget.fieldHeight,
        child: TextFormField(
          focusNode: focusNode,
          textDirection: widget.textDirection ?? (Session.isRTL ? TextDirection.rtl : TextDirection.ltr),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: widget.readOnly ?? false,
          cursorColor: widget.cursorColor ?? AppColors.primary,
          controller: widget.textEditingController,
          style: widget.fieldTextStyle ?? TextStyles.regular.copyWith(color: AppColors.black, fontSize: widget.fontSize ?? 15),
          textAlign: widget.textAlign ?? TextAlign.start,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength ?? 1000,
          obscureText: widget.obscureText ?? false,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(AppConstants.regexToRemoveEmoji)),
            SingleSpaceInputFormatter(),
            if (widget.textInputFormatter?.isNotEmpty ?? false) ...widget.textInputFormatter!],
          onChanged: (value) {
            items = allItems.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
            selectedItem = items.where((element) => element.toLowerCase().contains(value.toLowerCase())).firstOrNull ?? '';
            final index = items.indexOf(selectedItem);
            if (index != -1 && scrollController.hasClients) {
              scrollController.jumpTo(min(index * (context.height * 0.05), scrollController.position.maxScrollExtent));
            }
            ref.read(textFieldController).notifyListeners();
            widget.onChanged?.call(value);
          },
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          keyboardType: widget.textInputType ?? TextInputType.text,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          onTap: widget.onTap,
          decoration: InputDecoration(
            label: widget.hintText != null ? CommonText(title: widget.labelText ?? widget.hintText ?? '',style: widget.hintTextStyle ?? TextStyles.regular.copyWith(
              color: AppColors.clr7C7474, fontSize: 15
            ),) : null,
            contentPadding:widget.contentPadding?? EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: min(defaultHeight, widget.fieldHeight ?? defaultHeight) * 0.35),
            errorStyle: widget.errorStyle ?? TextStyles.regular.copyWith(fontSize: 15, color: AppColors.clrEA0604),
            errorMaxLines: 3,
            fillColor: widget.backgroundColor ?? AppColors.white,
            filled: true,
            isDense: true,
            alignLabelWithHint: true,
            enabled: widget.isEnable ?? true,
            counter: widget.counterWidget,
            counterText: widget.counterRequired ?? false ? null : '',
            counterStyle: widget.counterStyle ?? TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 15),
            floatingLabelBehavior:widget.floatingLabelBehavior,
            hintText: widget.hintText,
            hintStyle: widget.hintTextStyle ?? TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 15),
            suffixIcon: widget.giveConstraints ? widget.suffixWidget?.paddingOnly(right: context.width * 0.01) : widget.suffixWidget,
            suffixIconConstraints: widget.giveConstraints ? widget.suffixIconConstraints ?? BoxConstraints(maxHeight: context.height * 0.03, maxWidth: context.height * 0.05) : null,
            prefixIconConstraints: widget.prefixIconConstraints,
            prefixIcon: widget.prefixWidget,
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.clrACD7FF, width: widget.borderWidth ?? context.width * 0.001, style: BorderStyle.solid),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.red, width: widget.borderWidth ?? context.width * 0.001, style: BorderStyle.solid),
            ),
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.clrEAEAEA, width: widget.borderWidth ?? context.width * 0.001, style: BorderStyle.solid),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.clrEAEAEA, width: widget.borderWidth ?? context.width * 0.001, style: BorderStyle.solid),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.clrE7EAEE, width: widget.borderWidth ?? context.width * 0.001, style: BorderStyle.solid),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.red, width: widget.borderWidth ?? context.width * 0.001, style: BorderStyle.solid),
            ),
          ),
          onFieldSubmitted: (value) {
            if (widget.autoCompleteKey != null) {
              addInList(value);
            }
            FocusScope.of(context).nextFocus();
            widget.onFieldSubmitted?.call(value);
          },
          validator: widget.validator,
        ),
      ),
    );
  }

  String selectedItem = '';
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late FocusNode focusNode;
  List<String> items = [];
  List<String> allItems = [];

  void addInList(String input) {
    if (input.isNotEmpty && !allItems.contains(input)) {
      allItems.add(input);
      Session.setCacheData(widget.autoCompleteKey!, allItems);
      ref.read(textFieldController).notifyListeners();
    }
  }

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.autoCompleteKey != null) {
        allItems = Session.getCacheData(widget.autoCompleteKey!);
        items = allItems;
        selectedItem = items.firstOrNull ?? '';
        ref.read(textFieldController).notifyListeners();
        focusNode.addListener(_handleFocus);
      }
    });
    super.initState();
  }

  void _handleFocus() {
    if (focusNode.hasFocus) {
      _showOverlay();
    } else {
      addInList(widget.textEditingController.text);
      Future.delayed(Durations.short3, () => _removeOverlay());
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocus);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    // Handle only key down events
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    final currentIndex = items.indexOf(selectedItem);
    // Enter or Tab → Select current item
    if ((key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter || key == LogicalKeyboardKey.tab)) {
      if (selectedItem.isNotEmpty) {
        widget.textEditingController.text = selectedItem;
        widget.onSelected?.call(selectedItem);
        _removeOverlay();
      }
      addInList(widget.textEditingController.text);
      return true;
    }

    // Arrow navigation
    if (key == LogicalKeyboardKey.arrowDown) {
      final nextIndex = (currentIndex + 1).clamp(0, items.length - 1);
      if (nextIndex != currentIndex) {
        selectedItem = items[nextIndex];
        final index = items.indexOf(selectedItem);
        if (index != -1 && scrollController.hasClients) {
          final itemHeight = context.height * 0.05;
          final listOffsetTop = scrollController.position.pixels;
          final listOffsetBottom = listOffsetTop + context.height * 0.3;
          final itemTop = index * itemHeight;
          final itemBottom = itemTop + itemHeight;

          if (itemBottom > listOffsetBottom) {
            scrollController.jumpTo(min(itemBottom - context.height * 0.3, scrollController.position.maxScrollExtent));
          }
        }
        ref.read(textFieldController).notifyListeners();
      }
      return true;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      final prevIndex = (currentIndex - 1).clamp(0, items.length - 1);
      if (prevIndex != currentIndex) {
        selectedItem = items[prevIndex];
        final index = items.indexOf(selectedItem);
        if (index != -1 && scrollController.hasClients) {
          if (scrollController.position.pixels > index * (context.height * 0.05)) {
            scrollController.jumpTo(max(index * (context.height * 0.05), 0));
          }
        }
        ref.read(textFieldController).notifyListeners();
      }
      return true;
    }
    return false;
  }

  ScrollController scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    _removeOverlay();
    super.didChangeDependencies();
  }

  void _showOverlay() {
    _removeOverlay();
    if (!mounted) return; // Avoid duplicate overlays
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.fieldWidth ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: true,
          offset: Offset(0.0, (widget.fieldHeight ?? size.height)),
          child: Consumer(
            builder: (context, ref, child) {
              ref.watch(textFieldController);
              return DropdownExtendedWidget(
                scrollController: scrollController,
                textEditingController: widget.textEditingController,
                items: items,
                selectedItem: selectedItem,
                layerLink: _layerLink,
                focusNode: focusNode,
                onSelect: (item) {
                  widget.textEditingController.text = item;
                  selectedItem = item;
                  widget.onSelected?.call(selectedItem);
                  _removeOverlay();
                },
              );
            },
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class DropdownExtendedWidget extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController textEditingController;
  final List<String> items;
  final String selectedItem;
  final OverlayEntry? overlayEntry;
  final LayerLink layerLink;
  final FocusNode focusNode;
  final Function(String item) onSelect;

  const DropdownExtendedWidget({
    super.key,
    required this.scrollController,
    required this.textEditingController,
    required this.items,
    required this.selectedItem,
    this.overlayEntry,
    required this.layerLink,
    required this.focusNode,
    required this.onSelect,
  });

  @override
  State<DropdownExtendedWidget> createState() => _DropdownExtendedWidgetState();
}

class _DropdownExtendedWidgetState extends State<DropdownExtendedWidget> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final index = widget.items.indexOf(widget.selectedItem);
      if (index != -1 && widget.scrollController.hasClients) {
        widget.scrollController.jumpTo(min(index * (context.height * 0.05), widget.scrollController.position.maxScrollExtent));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(textFieldController);
        return Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: BoxConstraints(maxHeight: context.height * 0.3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ListView(
              padding: EdgeInsets.zero,
              controller: widget.scrollController,
              shrinkWrap: true,
              children: List.generate(widget.items.length, (index) {
                String item = widget.items[index];
                return LayoutBuilder(
                  builder: (context, cons) {
                    return InkWell(
                      onTap: () {
                        widget.onSelect.call(item);
                      },
                      child: Container(
                        height: context.height * 0.05,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: context.width * 0.01),
                        decoration: widget.selectedItem == item ? BoxDecoration(color: AppColors.blue0083FC.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)) : null,
                        child: CommonText(
                          title: item,
                          style: TextStyles.semiBold.copyWith(color: AppColors.black),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

final textFieldController = ChangeNotifierProvider((ref) => TextFieldController());

class TextFieldController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

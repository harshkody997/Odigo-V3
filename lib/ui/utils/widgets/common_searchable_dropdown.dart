import 'dart:async';
import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonSearchableDropdown<T> extends ConsumerStatefulWidget {
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String? hintText;
  final List<T> items;
  final TextStyle? hintTextStyle;
  final double? fieldWidth;
  final double? fieldHeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final TextStyle? fieldTextStyle;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? isEnable;
  final Widget? suffixWidget;
  final double? fontSize;
  final Function(T) onSelected;
  final Function()? onScrollListener;
  final String Function(T item) title;
  final FocusNode? passedFocus;
    T? selectedItem;
  final Function(String)? onSearch;
  final bool showLoader;
  final bool enableSearch;

  CommonSearchableDropdown({
    Key? key,
    required this.onSelected,
    required this.textEditingController,
    required this.items,
    this.validator,
    this.hintText,
    this.hintTextStyle,
    this.fieldWidth,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.fieldTextStyle,
    this.isEnable,
    this.suffixWidget,
    this.fieldHeight,
    this.fontSize,
    this.onFieldSubmitted,
    required this.title,
    this.onScrollListener,
    this.selectedItem,
    this.passedFocus,
    this.onSearch,
     this.showLoader = false,
    this.enableSearch=true,
  }) : super(key: key);

  @override
  ConsumerState<CommonSearchableDropdown<T>> createState() => _CommonSearchableDropdownState();
}

class _CommonSearchableDropdownState<T> extends ConsumerState<CommonSearchableDropdown<T>> {

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  FocusNode? focusNode;
  Timer? debounce;


  @override
  void initState() {
    focusNode = widget.passedFocus??FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // if(widget.selectedItem==null)
      //   {
      //     widget.selectedItem = widget.items.firstOrNull;
      //   }

      if (widget.selectedItem != null) widget.textEditingController.text = widget.title.call(widget.selectedItem!).capitalizeFirstLetterOfSentence;
      ref.read(searchController).notifyListeners();
      focusNode?.addListener(_handleFocus);

      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if(widget.onScrollListener != null){
            widget.onScrollListener!();
          }
        }
        // }
      });
    });
    super.initState();
  }

  void _handleFocus() {
    ref.read(searchController).notifyListeners();
    if (focusNode?.hasFocus??false) {
      _showOverlay();
    } else {
      Future.delayed(Duration.zero, () => _removeOverlay());
    }
  }

  @override
  void dispose() {
    focusNode?.removeListener(_handleFocus);
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultHeight = context.height * 0.07;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Opacity(
        opacity: widget.isEnable??true?1:0.6,
        child: CommonInputFormField(
          fieldWidth: widget.fieldWidth,
          fieldHeight: widget.fieldHeight,
          focusNode: focusNode,
          readOnly: !widget.enableSearch,
          borderRadius: widget.borderRadius??  BorderRadius.circular(8),
          cursorColor: AppColors.primary,
          contentPadding:EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: min(defaultHeight, widget.fieldHeight ?? defaultHeight) * 0.35),
          textEditingController: widget.textEditingController,
          fieldTextStyle: widget.fieldTextStyle ?? TextStyles.regular.copyWith(color: AppColors.black, fontSize: widget.fontSize ?? 15),
          textAlign: TextAlign.start,
          onChanged: (value) async {
            if (debounce?.isActive ?? false) debounce!.cancel();
            debounce = Timer(const Duration(milliseconds: 500), () async {
              if(value.length != 1) {
                if(widget.onSearch != null){
                  await widget.onSearch?.call(value);
                }
                widget.selectedItem = widget.items.where((element) => widget.title(element).toLowerCase().containsCharactersInOrder(value.toLowerCase())).firstOrNull;
                print('--------------_>${widget.selectedItem}');
                if (widget.selectedItem == null) return;
                var index = widget.items.indexOf(widget.selectedItem!);
                if (index == -1) widget.selectedItem = widget.items.firstOrNull;
                index = widget.items.indexOf(widget.selectedItem!);
                if (index != -1 && scrollController.hasClients) {
                  scrollController.jumpTo(min(index * (context.height * 0.05), scrollController.position.maxScrollExtent));
                }
                ref.read(searchController).notifyListeners();
              }
            });
          },
          isEnable: widget.isEnable ?? true,
          hintText: widget.hintText,
          hintTextStyle: widget.hintTextStyle ?? TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 15),
          suffixWidget: widget.suffixWidget != null
              ? Padding(padding: const EdgeInsets.all(2), child: widget.suffixWidget)
              : InkWell(
                  onTap: () {
                    if (focusNode?.hasFocus??false) {
                      focusNode?.unfocus();
                    } else {
                      focusNode?.requestFocus();
                    }
                  },
                  child: Consumer(
                    builder: (context, ref, child) {
                      ref.watch(searchController);
                      return RotatedBox(
                        quarterTurns: focusNode?.hasFocus??false ? 2 : 0,
                        child: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
                      );
                    },
                  ),
                ),
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
        ),
      ),
    );
  }

  bool _onKey(KeyEvent event) {
    // Handle only key down events
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    var currentIndex = 0;
    if (widget.selectedItem != null) currentIndex = widget.items.indexOf(widget.selectedItem!);
    if (currentIndex == -1) currentIndex = 0;
    // Enter or Tab → Select current item
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter || key == LogicalKeyboardKey.tab) {
      if (widget.selectedItem != null) {
        widget.textEditingController.text = widget.title.call(widget.selectedItem!).capitalizeFirstLetterOfSentence;
        widget.onSelected.call(widget.selectedItem!);
        focusNode?.unfocus();
        ref.read(searchController).notifyListeners();
        _removeOverlay();
      }
      return true;
    }

    // Arrow navigation
    if (key == LogicalKeyboardKey.arrowDown) {
      final nextIndex = (currentIndex + 1).clamp(0, widget.items.length - 1);
      if (nextIndex != currentIndex) {
        widget.selectedItem = widget.items[nextIndex];
        final index = widget.items.indexOf(widget.selectedItem!);
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
        ref.read(searchController).notifyListeners();
      }
      return true;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      final prevIndex = (currentIndex - 1).clamp(0, widget.items.length - 1);
      if (prevIndex != currentIndex) {
        widget. selectedItem = widget.items[prevIndex];
        final index = widget.items.indexOf(widget.selectedItem!);
        if (index != -1 && scrollController.hasClients) {
          if (scrollController.position.pixels > index * (context.height * 0.05)) {
            scrollController.jumpTo(max(index * (context.height * 0.05), 0));
          }
        }
        ref.read(searchController).notifyListeners();
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
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Calculate available space above and below, and decide where to open dropdown
    final screenHeight = MediaQuery.of(context).size.height;
    final renderBoxOffset = renderBox.localToGlobal(Offset.zero);
    final spaceBelow = screenHeight - (renderBoxOffset.dy + size.height);
    final spaceAbove = renderBoxOffset.dy;
    final openAbove = spaceBelow < (context.height * 0.3) && spaceAbove > spaceBelow;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.fieldWidth ?? size.width,
        child: Consumer(
          builder: (context, ref, child) {
            final searchWatch = ref.watch(searchController);
            final dropdownOffset = openAbove ? Offset(0.0, -((min(context.height * 0.3, widget.showLoader && searchWatch.isLoading ? context.height * 0.2 : (context.height * 0.05 * widget.items.length))) + 10)) : Offset(0.0, (widget.fieldHeight ?? size.height) + 10);
            return CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: true,
              offset: dropdownOffset,
              child: DropdownExtendedWidget<T>(
                scrollController: scrollController,
                textEditingController: widget.textEditingController,
                items: widget.items,
                selectedItem: widget.selectedItem,
                layerLink: _layerLink,
                onSelect: (item) {
                  if (item != null) {
                    widget.textEditingController.text = (widget.title).call(item);
                    widget.selectedItem = item;
                    focusNode?.unfocus();
                    widget.onSelected.call(widget.selectedItem!);
                    ref.read(searchController).notifyListeners();
                  }
                  _removeOverlay();
                },
                title: widget.title,
                showLoader: widget.showLoader,
              ),
            );
          },
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

class DropdownExtendedWidget<T> extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController textEditingController;
  final List<T> items;
   T? selectedItem;
  final OverlayEntry? overlayEntry;
  final LayerLink layerLink;
  final String Function(T item) title;
  final Function(T item) onSelect;
  final bool showLoader;

   DropdownExtendedWidget({
    super.key,
    required this.scrollController,
    required this.textEditingController,
    required this.items,
    required this.selectedItem,
    required this.title,
    this.overlayEntry,
    required this.layerLink,
    required this.onSelect,
     required this.showLoader,
  });

  @override
  State<DropdownExtendedWidget<T>> createState() => _DropdownExtendedWidgetState<T>();
}

class _DropdownExtendedWidgetState<T> extends State<DropdownExtendedWidget<T>> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.selectedItem == null) return;
      final index = widget.items.indexOf(widget.selectedItem!);
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
        final searchWatch = ref.watch(searchController);
        return Material(
          elevation: 5,
          color: AppColors.white,
          borderOnForeground: true,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: BoxConstraints(maxHeight: context.height * 0.3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(1)),
            child: widget.showLoader && searchWatch.isLoading
                ? SizedBox(
                    height: context.height * 0.2,
                    child: CommonAnimLoader().paddingSymmetric(vertical: context.height * 0.05),
                  )
                : ListView(
              padding: EdgeInsets.zero,
              controller: widget.scrollController,
              shrinkWrap: true,
              children: [
                ...List.generate(widget.items.length, (index) {
                T item = widget.items[index];
                return Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (event) {
                    widget.selectedItem = item;
                    ref.read(searchController).notifyListeners();
                    widget.onSelect.call(item);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: context.height * 0.05,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: context.width * 0.015),
                    //  decoration: widget.selectedItem == item ? BoxDecoration(color: AppColors.clr2997FC, borderRadius: BorderRadius.circular(10)) : null,
                      decoration: widget.selectedItem == item ? BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)) : null,
                      child:
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                            widget.selectedItem = item;
                            ref.read(searchController).notifyListeners();
                            widget.onSelect.call(item);
                        },
                       child:
                        CommonText(
                          title: widget.title.call(item),
                          style: TextStyles.semiBold.copyWith(color: widget.selectedItem == item ? AppColors.white : AppColors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              },),
                if(searchWatch.isLoadMore == true) Center(child: CircularProgressIndicator(strokeWidth: 3))
              ],
            ),
          ),
        );
      },
    );
  }
}

final searchController = ChangeNotifierProvider((ref) => SearchDropdownController());

class SearchDropdownController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  bool isLoading = false;
  void updateLoader(bool value){
    isLoading = value;
    notifyListeners();
  }

  bool isLoadMore = false;
  void updateLoadMore(bool value){
    isLoadMore = value;
    notifyListeners();
  }
}

/// for showing loader
//  make showLoader: true,
/// then put this update loader funtion in search controller to show/hide loader
// {
//   ref.read(searchController).updateLoader(true);
//   // api call
//   ref.read(searchController).updateLoader(false);
// }


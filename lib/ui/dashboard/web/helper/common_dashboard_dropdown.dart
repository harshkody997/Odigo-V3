import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardDropdown extends ConsumerStatefulWidget {
  final String placeholder;
  final List<dynamic>? items;
  final double itemHeight;
  final Function(dynamic value) onChanged;
  final double width;
  final dynamic value;

  const CommonDashboardDropdown({
    super.key,
    required this.placeholder,
    required this.items,
    required this.onChanged,
    required this.itemHeight,
    required this.width,
    required this.value,
  });

  @override
  ConsumerState<CommonDashboardDropdown> createState() => _CommonDashboardDropdownState();
}

class _CommonDashboardDropdownState extends ConsumerState<CommonDashboardDropdown> {
  dynamic selectedItem;
  final ScrollController scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void didChangeDependencies() {
    _removeOverlay();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    selectedItem = widget.value;
    return InkWell(
      onTap: _showOverlay,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          width: widget.width,
          decoration: selectedItem != null
              ? BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.clr4793EB, AppColors.clr2367EC]),
            borderRadius: BorderRadius.circular(16),
          )
              : BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.clrF4F5F7,
            border: Border.all(color: AppColors.clrDEDEDE),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.005,
            vertical: context.height * 0.01,
          ),
          child: Row(
            children: [
              Expanded(
                child: CommonText(
                  title: getLocalizedMonth(widget.placeholder),
                  style: TextStyles.regular.copyWith(
                    fontSize: 10,
                    color: selectedItem != null ? AppColors.white : AppColors.clr828282,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: selectedItem != null ? AppColors.white : AppColors.clr828282,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    _removeOverlay();
    if (!mounted) return;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeOverlay,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: true,
              offset: Offset(0, 0),
              child: Consumer(
                builder: (context, ref, child) {
                  ref.watch(dashboardDropdownController);
                  return DashboardDropdownExtendedWidget(
                    scrollController: scrollController,
                    items: widget.items ?? [],
                    selectedItem: selectedItem,
                    layerLink: _layerLink,
                    onSelect: (item) {
                      selectedItem = item;
                      widget.onChanged.call(selectedItem);
                      _removeOverlay();
                    },
                    itemHeight: widget.itemHeight,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class DashboardDropdownExtendedWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<dynamic> items;
  final double itemHeight;
  final dynamic selectedItem;
  final OverlayEntry? overlayEntry;
  final LayerLink layerLink;
  final Function(dynamic item) onSelect;

  const DashboardDropdownExtendedWidget({
    super.key,
    required this.scrollController,
    required this.itemHeight,
    required this.items,
    required this.selectedItem,
    this.overlayEntry,
    required this.layerLink,
    required this.onSelect,
  });

  @override
  State<DashboardDropdownExtendedWidget> createState() => _DashboardDropdownExtendedWidgetState();
}

class _DashboardDropdownExtendedWidgetState extends State<DashboardDropdownExtendedWidget> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final index = widget.items.indexOf(widget.selectedItem);
      if (index != -1 && widget.scrollController.hasClients) {
        widget.scrollController.jumpTo(
          min(
            index * (context.height * widget.itemHeight),
            widget.scrollController.position.maxScrollExtent,
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(dashboardDropdownController);
        return Material(
          elevation: 0,
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: BoxConstraints(maxHeight: context.height * 0.3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.clrF4F5F7,
              border: Border.all(color: AppColors.clrDEDEDE),
            ),
            child: ListView.builder(
              controller: widget.scrollController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = widget.selectedItem == item;
                return InkWell(
                  onTap: () => widget.onSelect.call(item),
                  child: Container(
                    height: context.height * widget.itemHeight,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.005),
                    decoration: isSelected
                        ? BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.clr4793EB, AppColors.clr2367EC]),
                      borderRadius: BorderRadius.circular(16),
                    )
                        : null,
                    child: CommonText(
                      title: getLocalizedMonth(item),
                      textAlign: TextAlign.center,
                      style: TextStyles.semiBold.copyWith(
                        color: isSelected ? AppColors.white : AppColors.black,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

final dashboardDropdownController = ChangeNotifierProvider((ref) => DashboardDropdownController());

class DashboardDropdownController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

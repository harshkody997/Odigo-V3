import 'package:flutter/cupertino.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/utils/app_enums.dart';

class DrawerModel {
  final String menuName;
  final String strIcon;
  bool isExpanded;
  final ScreenName screenName;
  final List<DashboardSubScreen>? dropDownList;
  NavigationStackItem? item;

  DrawerModel({required this.menuName, required this.strIcon, this.isExpanded = false, required this.screenName, this.dropDownList, this.item});
}

class DashboardSubScreen {
  String title;
  ScreenName screenName;
  NavigationStackItem item;

  DashboardSubScreen({required this.screenName, required this.item, required this.title});
}

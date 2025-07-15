import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/country/mobile/add_edit_country_mobile.dart';
import 'package:odigov3/ui/master/country/web/add_edit_country_web.dart';

class AddEditCountry extends ConsumerStatefulWidget{
  final bool? isEdit;
  const AddEditCountry({Key? key,this.isEdit}) : super(key: key);

  @override
  ConsumerState<AddEditCountry> createState() => _AddEditCountryState();
}

class _AddEditCountryState extends ConsumerState<AddEditCountry> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const AddEditCountryMobile();
      },
      desktop: (BuildContext context) {
        return AddEditCountryWeb(isEdit: widget.isEdit);
      },
    );
  }
}


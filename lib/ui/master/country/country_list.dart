import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/country/mobile/country_list_mobile.dart';
import 'package:odigov3/ui/master/country/web/country_list_web.dart';

class CountryList extends ConsumerStatefulWidget{
  const CountryList({Key? key}) : super(key: key);

  @override
  ConsumerState<CountryList> createState() => _CountryListState();
}

class _CountryListState extends ConsumerState<CountryList> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final countryListWatch = ref.read(countryListController);
      countryListWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        await countryListWatch.getCountryListAPI(context);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const CountryListWeb();
      },
      desktop: (BuildContext context) {
        return const CountryListWeb();
      },
      tablet: (BuildContext context) {
        return const CountryListWeb();
      },
    );
  }
}


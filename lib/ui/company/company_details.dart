import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/company/company_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/company/web/company_details_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CompanyDetails extends ConsumerStatefulWidget {
  const CompanyDetails({super.key});

  @override
  ConsumerState<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends ConsumerState<CompanyDetails> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final companyRead = ref.read(companyController);
    companyRead.disposeController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
       ///company detail api
        await companyRead.getCompanyDetail(context);
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const CompanyDetailsWeb();
      },
      tablet: (BuildContext context) {
        return const CompanyDetailsWeb();
      },
      desktop: (BuildContext context) {
        return const CompanyDetailsWeb();
      },
    );
  }
}


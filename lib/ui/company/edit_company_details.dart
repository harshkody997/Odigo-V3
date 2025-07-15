import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/company/company_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/company/web/edit_company_details_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditCompanyDetails extends ConsumerStatefulWidget {
  const EditCompanyDetails({super.key});

  @override
  ConsumerState<EditCompanyDetails> createState() => _EditCompanyDetailsState();
}

class _EditCompanyDetailsState extends ConsumerState<EditCompanyDetails> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final companyRead = ref.read(companyController);
    companyRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {

      await companyRead.getCompanyDetail(context);
      companyRead.getLanguageListModel();
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const EditCompanyDetailsWeb();
      },
      tablet: (BuildContext context) {
        return const EditCompanyDetailsWeb();
      },
      desktop: (BuildContext context) {
        return const EditCompanyDetailsWeb();
      },
    );
  }
}


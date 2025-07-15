import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/faq/add_edit_faq_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/faq/web/add_edit_faq_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddEditFaq extends ConsumerStatefulWidget {
  final String? faqUuid;
  const AddEditFaq({super.key, this.faqUuid});

  @override
  ConsumerState<AddEditFaq> createState() => _AddEditFaqState();
}

class _AddEditFaqState extends ConsumerState<AddEditFaq> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final addEditFaqRead = ref.read(addEditFaqController);
    addEditFaqRead.disposeController();
    addEditFaqRead.getLanguageListModel();
    if(widget.faqUuid != null){
      addEditFaqRead.faqDetailState.isLoading = true;
    }else{
      addEditFaqRead.getLanguageListModel();
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if(widget.faqUuid != null) {
        await addEditFaqRead.faqDetailApi(context, widget.faqUuid ?? '');
        addEditFaqRead.getLanguageListModel();
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return AddEditFaqWeb(faqUuid: widget.faqUuid);
        },
        tablet: (BuildContext context) {
          return AddEditFaqWeb(faqUuid: widget.faqUuid);
        },
        desktop: (BuildContext context) {
          return AddEditFaqWeb(faqUuid: widget.faqUuid);
        },
    );
  }
}


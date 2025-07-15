import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/ticket_management/web/helper/create_ticket_form_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CreateTicketWeb extends ConsumerStatefulWidget {
  const CreateTicketWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateTicketWeb> createState() => _CreateTicketWebState();
}

class _CreateTicketWebState extends ConsumerState<CreateTicketWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      isApiLoading: ref.watch(ticketReasonListController).ticketReasonListState.isLoading,
      body: ref.watch(ticketReasonListController).ticketReasonListState.isLoading ? CommonAnimLoader()
        : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
            BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// create ticket  text
              CommonText(title: LocaleKeys.keyCreateTicket.localized, fontWeight: TextStyles.fwSemiBold,fontSize: 14,).paddingOnly(bottom: 24),

              /// ticket  textField form widget
              CreateTicketFormWidget(),
            ],
          ).paddingAll(context.height * 0.025).paddingAll(context.height * 0.01),
        ),
      ),
    );
  }
}

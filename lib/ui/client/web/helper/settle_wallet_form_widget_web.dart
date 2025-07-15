import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/wallet_transactions/wallet_transactions_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class SettleWalletFormWidgetWeb extends ConsumerWidget {
  final String clientUuid;
  const SettleWalletFormWidgetWeb({super.key,required this.clientUuid, });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Form(
      key: clientDetailsWatch.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Transaction type and amount field
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 17,
                  child:  Focus(
                    onKey: (FocusNode node, RawKeyEvent event) {
                      if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                        clientDetailsWatch.amountFocusNode.requestFocus();
                        // Prevent focus shift on Enter
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: CommonSearchableDropdown<CommonEnumTitleValueModel>(
                      enableSearch: false,
                      borderRadius: BorderRadius.circular(7),
                      selectedItem:clientDetailsWatch.selectedSettleTransactionType,
                      onSelected: (value) async{
                        clientDetailsWatch.amountFocusNode.requestFocus();
                        clientDetailsWatch.updateSelectedTransactionType(value);
                      },
                      validator: (value){
                        if(clientDetailsWatch.selectedTransactionCtr.text.isEmpty){
                          return LocaleKeys.keyTransactionTypeRequiredMsg.localized;
                        }
                      },
                      hintText: LocaleKeys.keySelectTransactionType.localized,
                      textEditingController: clientDetailsWatch.selectedTransactionCtr,
                      items: clientDetailsWatch.settleWalletTransactionsTypeList,
                      title: (CommonEnumTitleValueModel transaction) {
                        return transaction.title.localized;
                      },
                    ),
                  )
              ),
              const Spacer(),
              Expanded(
                  flex: 17,
                  child:  CommonInputFormField(
                    focusNode: clientDetailsWatch.amountFocusNode,
                    textEditingController: clientDetailsWatch.amountCtr,
                    hintText: LocaleKeys.keyEnterSettleAmount.localized,
                    validator: (value) {
                      if(value?.isEmpty??false){
                        return validateText(value, LocaleKeys.keySettleAmountRequiredMsg.localized);
                      }else if(int.parse(clientDetailsWatch.amountCtr.text) <=0){
                        return LocaleKeys.keySettleAmountNotZeroValidationMsg.localized;
                      }
                    },
                    textInputType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      clientDetailsWatch.remarksFocusNode.requestFocus();
                    },
                    maxLength: AppConstants.maxAmountLength,
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  )
              ),
            ],
          ).paddingOnly(bottom: 20),
          /// Remarks
          CommonInputFormField(
            textEditingController: clientDetailsWatch.remarksCtr,
            maxLength: AppConstants.maxDescriptionLength,
            hintText: LocaleKeys.keyRemarksOptional.localized,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: clientDetailsWatch.remarksFocusNode,
            maxLines: 6,
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9/ .]')),
            ],
            onFieldSubmitted: (val) async{
              if(clientDetailsWatch.formKey.currentState?.validate() ?? false) {
                /// Api call
                await clientDetailsWatch.settleWalletApi(clientUuid: clientUuid).then((value) {
                  if(clientDetailsWatch.settleWalletState.success?.status == ApiEndPoints.apiStatus_200){
                    /// Client detail api
                    clientDetailsWatch.clientDetailsApi(context, clientUuid);
                    /// Dispose wallet list
                    ref.watch(walletTransactionsController).disposeController();
                    /// Wallet list api
                    ref.watch(walletTransactionsController).walletListApi(false,clientUuid: clientUuid);
                    /// Success toast
                    showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyWalletAmount.localized} ${LocaleKeys.keyUpdatedSuccessMsg.localized}');
                    /// Back
                    ref.read(navigationStackController).pop();
                  }
                },);
              }
            },
          )
        ],
      ),
    );

  }
}





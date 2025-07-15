import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_list_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/repository/purchase/contract/purchase_repository.dart';
import 'package:odigov3/framework/repository/purchase/model/request/create_purchase_request_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_weeks_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';

final addPurchaseController = ChangeNotifierProvider((ref) => getIt<AddPurchaseController>());

@injectable
class AddPurchaseController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    destinationTypeSearchCtr.clear();
    selectedDestination = null;
    purchaseType = PurchaseType.PREMIUM;
    isCalculated = false;
    selectedWeeks = [];
    paymentType = PaymentType.PARTIAL;
    isWalletUsedForPayment = false;
    partialPaymentsList = [];
    purchaseWeeksState.success=null;
    finalWeeklyPrice = 0;
    weeklyAmount = 0;
    discountAmount = 0;
    totalAmount = 0;
    finalPurchasePriceCtr.clear();
    remarkTextController.clear();
    scheduledAmount = 0.0;
    remainingAmount = 0.0;
    remarksCtr.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  /// select destination
  TextEditingController destinationTypeSearchCtr = TextEditingController();
  DestinationData? selectedDestination;
  void updateSelectedDestination(DestinationData? destination){
    selectedDestination = destination;
    selectedWeeks=[];
    clearDateAndPartialPaymentValue();
    if(selectedWeeks.isEmpty || selectedWeeks==[]){
      finalWeeklyPrice=0;
      weeklyAmount=0;
      totalAmount=0;
      finalPurchaseAmount=0;
      finalPurchasePriceCtr.clear();
      scheduledAmount = 0.0;
      remainingAmount = 0.0;
    }
    notifyListeners();
  }

  /// purchase type
  PurchaseType purchaseType = PurchaseType.PREMIUM;
  updatePurchaseType(PurchaseType type){
    purchaseType = type;
    notifyListeners();
  }

  /// week
  List<PurchaseWeeksData> selectedWeeks = [];

  void updateSelectedWeek(PurchaseWeeksData week, bool? checked) {
    if (checked == true) {
      selectedWeeks.add(week);
      selectedWeeks.sort((a, b) {
        final aWeek = a.weekNumber ?? 0;
        final bWeek = b.weekNumber ?? 0;
        return aWeek.compareTo(bWeek);
      });
    } else {
      selectedWeeks.removeWhere((w) => w.weekNumber == week.weekNumber);
    }
    clearDateAndPartialPaymentValue();
    notifyListeners();
  }


  void addAllWeeks(bool? checked) {
    final weeks = purchaseWeeksState.success?.data ?? [];

    if (checked == true) {
      selectedWeeks.addAll(weeks);
    } else {
      selectedWeeks.removeWhere(weeks.contains);
    }

    selectedWeeks = selectedWeeks.toSet().toList(); // remove duplicates
    notifyListeners();
  }

  /// for calculate
  bool isCalculated = false;
  void updateIsCalculated(bool value){
    isCalculated = value;
    notifyListeners();
  }

  TextEditingController finalPurchasePriceCtr = TextEditingController();
  TextEditingController remarksCtr = TextEditingController();

  int finalWeeklyPrice = 0;

  ///Chart Value
  double weeklyAmount = 0.0;
  double discountAmount = 0.0;
  int totalAmount = 0;
  int finalPurchaseAmount = 0;

  ///CalculateWeekly Price
  void calculateWeeklyPrice(int price){
    finalWeeklyPrice = (price * selectedWeeks.length);
    totalAmount=finalWeeklyPrice;
    finalPurchaseAmount=finalWeeklyPrice;
    weeklyAmount= price.toDouble();
    finalPurchasePriceCtr.text='${finalWeeklyPrice}';

    if(selectedWeeks.isEmpty || selectedWeeks==[]){
      finalWeeklyPrice=0;
      weeklyAmount=0;
      totalAmount=0;
      finalPurchaseAmount=0;
      finalPurchasePriceCtr.clear();
      scheduledAmount = 0.0;
      remainingAmount = 0.0;
    }
    notifyListeners();
  }

  ///Change Discount Price
  void changePurchasePrice(String value) {
    final int? parsedValue = int.tryParse(value==''?'0':value);

    if (parsedValue == null) {
      return;
    }

    if (parsedValue <= finalWeeklyPrice) {
      discountAmount = (finalWeeklyPrice - parsedValue).toDouble();
      finalPurchaseAmount = parsedValue;
      notifyListeners();
    }
  }

  /// payment type
  PaymentType paymentType = PaymentType.PARTIAL;
  updatePaymentType(PaymentType type){
    paymentType = type;
    if(paymentType==PaymentType.PARTIAL){
      partialPaymentsList=[];
      addValueInPartialPayment();
    }
    notifyListeners();
  }

  /// wallet use for payment
  bool isWalletUsedForPayment = false;
  void updateIsWalletUsedForPayment(bool value){
    isWalletUsedForPayment = value;
    notifyListeners();
  }

  ///Partial Payment
  List<PartialPaymentModel> partialPaymentsList = [];

  ///Add Value in partial payment
  void addValueInPartialPayment(){
    partialPaymentsList.add(
      PartialPaymentModel(
        amountController: TextEditingController(),
        dateController: TextEditingController(),
        dateValue: null,
        formKey: GlobalKey<FormState>(),
      ),
    );
    notifyListeners();
  }

  void removeValueInPartialPayment(int index){
    partialPaymentsList.removeAt(index);
    notifyListeners();
  }

  ///Update Payment Date
  void updatePartialPaymentDate(DateTime paymentDate,int index) {
    partialPaymentsList[index].dateValue=paymentDate;
    partialPaymentsList[index].dateController?.text=formatDateToDDMMYYYY(paymentDate);
    notifyListeners();
  }

  ///Form Keys
  final purchaseFormKey = GlobalKey<FormState>();

  GlobalKey purchaseSuccessfulDialogKey = GlobalKey();
  GlobalKey remarkDialogKey = GlobalKey();

  FocusNode remarkNode = FocusNode();
  TextEditingController remarkTextController = TextEditingController();

  double scheduledAmount = 0.0;
  double remainingAmount = 0.0;

  ///Count Schedule Amount
  void countAmount(){
    scheduledAmount = 0.0;
    for (var element in partialPaymentsList) {
      final amountText = element.amountController?.text ?? '0.0';
      final parsedAmount = double.tryParse(amountText) ?? 0.0;
      scheduledAmount += parsedAmount;
    }
    remainingAmount = finalPurchaseAmount.toDouble()-scheduledAmount;
    notifyListeners();
  }

  ///Clear Date and Partial Payment
  void clearDateAndPartialPaymentValue(){
    remarksCtr.clear();
    partialPaymentsList=[];
    addValueInPartialPayment();
    scheduledAmount = 0.0;
    remainingAmount = 0.0;
    notifyListeners();
  }

  ///------------------------------------------API Integration--------------------------------------///

  PurchaseRepository purchaseRepository;
  AddPurchaseController(this.purchaseRepository);

  ///Purchase Week api
  UIState<PurchaseWeeksResponseModel> purchaseWeeksState = UIState<PurchaseWeeksResponseModel>();

  Future<void> purchaseWeeksApi({String? destinationUuid}) async {
    purchaseWeeksState.isLoading=true;
    purchaseWeeksState.success=null;
    notifyListeners();

    final result = await purchaseRepository.purchaseWeeksApi(destinationUuid??'');
    result.when(
      success: (data) async {
        purchaseWeeksState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseWeeksState.isLoading = false;
    notifyListeners();
  }

  ///Create Purchase api
  UIState<CommonResponseModel> createPurchaseState = UIState<CommonResponseModel>();

  Future<void> createPurchaseApi({String? clientUuid,required List<ClientAdsListDto?> clientAdsList}) async {
    createPurchaseState.isLoading = true;
    createPurchaseState.success = null;
    notifyListeners();


    ///Weeks List
    List<PurchaseWeek>? purchaseWeeks = [];

    selectedWeeks.forEach((element){
      purchaseWeeks.add(PurchaseWeek(week: element.weekNumber,startDate: element.startDate,endDate: element.endDate,year: element.year));
    });

    print('-----SELECT:${selectedWeeks.length}${purchaseWeeks.length}');

    ///Payment List
    List<Payment>? payments= [];

    partialPaymentsList.forEach((element){
      payments.add(Payment(price: int.tryParse(element.amountController?.text??'0'),installmentDate: element.dateValue));
    });


    ///Ads List
    List<String> adsUuid = [];

    ///Selected Ads Count
    clientAdsList.forEach((element){
      if(element?.isSelected==true){
        adsUuid.add(element?.uuid??'');
      }
    });

    CreatePurchaseRequestModel requestModel = CreatePurchaseRequestModel(
        odigoClientUuid: clientUuid,
        destinationUuid: selectedDestination?.uuid??'',
        type: purchaseType.name,
        paymentType: paymentType.name,
        payments: paymentType==PaymentType.PARTIAL?payments:null,
        remarks: remarkTextController.text,
        adsUuids: adsUuid,
        purchaseWeeks: purchaseWeeks,
        purchasePrice: int.parse(finalPurchasePriceCtr.text),
        isConsiderWalletBalance: isWalletUsedForPayment,
        //purchaseUuid: purchaseUuid
    );
    String request = createPurchaseRequestModelToJson(requestModel);

    final result = await purchaseRepository.createPurchaseApi(request: request);
    result.when(
      success: (data) async {
        createPurchaseState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );
    createPurchaseState.isLoading = false;
    notifyListeners();
  }

}

class PartialPaymentModel{
  TextEditingController? amountController;
  TextEditingController? dateController;
  DateTime? dateValue;
  GlobalKey<FormState> formKey;

  PartialPaymentModel({required this.amountController,required this.dateController,required this.dateValue,required this.formKey});
}

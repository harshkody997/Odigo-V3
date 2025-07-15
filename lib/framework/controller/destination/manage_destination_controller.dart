import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_multilanguage_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/request/manage_destination_request_model.dart';
import 'package:odigov3/framework/repository/master/city/model/city_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/extension/time_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:http_parser/http_parser.dart';

final manageDestinationController = ChangeNotifierProvider((ref) => getIt<ManageDestinationController>());

@injectable
class ManageDestinationController extends ChangeNotifier {
  DestinationDetailsRepository destinationDetailsRepository;

  ManageDestinationController(this.destinationDetailsRepository);


  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    destinationFormKey.currentState?.reset();
    destinationNameTextFields.clear();
    manageDestinationState.success = null;
    manageDestinationState.isLoading = false;
    destinationDetailsState.success = null;
    destinationDetailsState.isLoading = false;

    selectDestinationTypeController.clear();
    selectedDestinationType = null;
    numberOfFloorController.clear();
    passcodeController.clear();
    ownerNameController.clear();
    ownerEmailIdController.clear();
    ownerContactController .clear();
    ownerPasswordController.clear();
    addressHouseNumberController.clear();
    addressStreetNameController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    addressLandmarkController.clear();
    addressCountryController.clear();
    addressStateController.clear();
    addressCityController.clear();
    addressPostalCodeController.clear();
    addressTimeZoneController.clear();
    premiumPriceController.clear();
    fillerPriceController.clear();
    addressCityController.clear();
    addressStateController.clear();
    selectedCountry = null;
    selectedState = null;
    selectedCity = null;
    isPasswordVisible = false;
    isOwnerPasswordVisible = false;
    isPasscodeVisible = false;
    destinationImage = null;
    selectedTimeZone = null;
    applyToAllDaysIndex = null;
    destinationTimingsList = [
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.MONDAY.name, startHour: null, endHour: null),
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.TUESDAY.name, startHour: null, endHour: null),
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.WEDNESDAY.name, startHour: null, endHour: null),
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.THURSDAY.name, startHour: null, endHour: null),
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.FRIDAY.name, startHour: null, endHour: null),
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.SATURDAY.name, startHour: null, endHour: null),
      DestinationTimeValue(dayOfWeek: DestinationDaysEnum.SUNDAY.name, startHour: null, endHour: null),
    ];
    if (isNotify) {
      notifyListeners();
    }
  }


  GlobalKey<FormState> destinationFormKey = GlobalKey();

  TextEditingController selectDestinationTypeController = TextEditingController();
  TextEditingController numberOfFloorController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController ownerEmailIdController = TextEditingController();
  TextEditingController ownerContactController = TextEditingController();
  TextEditingController ownerPasswordController = TextEditingController();
  TextEditingController addressHouseNumberController = TextEditingController();
  TextEditingController addressStreetNameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController addressLandmarkController = TextEditingController();
  TextEditingController addressStateController = TextEditingController();
  TextEditingController addressCityController = TextEditingController();
  TextEditingController addressPostalCodeController = TextEditingController();
  TextEditingController addressTimeZoneController = TextEditingController();
  TextEditingController premiumPriceController = TextEditingController();
  TextEditingController fillerPriceController = TextEditingController();
  TextEditingController addressCountryController = TextEditingController();
  StateModel? selectedState;
  CountryModel? selectedCountry;

  FocusNode numberOfFloorFocusNode = FocusNode();
  FocusNode passcodeFocusNode = FocusNode();
  FocusNode ownerNameFocusNode = FocusNode();
  FocusNode ownerEmailIdFocusNode = FocusNode();
  FocusNode ownerContactFocusNode = FocusNode();
  FocusNode ownerPasswordFocusNode = FocusNode();
  FocusNode addressHouseNumberFocusNode = FocusNode();
  FocusNode addressStreetNameFocusNode = FocusNode();
  FocusNode addressLine1FocusNode = FocusNode();
  FocusNode addressLine2FocusNode = FocusNode();
  FocusNode addressLandmarkFocusNode = FocusNode();
  FocusNode addressStateFocusNode = FocusNode();
  FocusNode addressCityFocusNode = FocusNode();
  FocusNode addressPostalCodeFocusNode = FocusNode();
  FocusNode addressTimeZoneFocusNode = FocusNode();
  FocusNode premiumPriceFocusNode = FocusNode();
  FocusNode fillerPriceFocusNode = FocusNode();

  fillDataOnDetails(BuildContext context, DestinationDetailsMultiLanguage destinationData) {
    selectDestinationTypeController.text = destinationData.destinationTypeName ?? '';
    numberOfFloorController.text = (destinationData.totalFloor ?? 0).toString();
    passcodeController.text = destinationData.passcode ?? '';
    ownerNameController.text = destinationData.ownerName ?? '';
    ownerEmailIdController.text = destinationData.email ?? '';
    ownerContactController.text = destinationData.contactNumber ?? '';
    addressHouseNumberController.text = destinationData.houseNumber ?? '';
    addressStreetNameController.text = destinationData.stateName ?? '';
    addressLine1Controller.text = destinationData.addressLine1 ?? '';
    addressLine2Controller.text = destinationData.addressLine2 ?? '';
    addressLandmarkController.text = destinationData.landmark ?? '';
    addressPostalCodeController.text = destinationData.postalCode ?? '';
    addressTimeZoneController.text = destinationData.timeZone ?? '';
    premiumPriceController.text = (destinationData.premiumPrice ?? 0).toString();
    fillerPriceController.text = (destinationData.fillerPrice ?? 0).toString();
    updateCountryDropdown(AppConstants.constant.globalRef?.read(countryListController).countryList.where((country) => country.uuid == destinationData.countryUuid).firstOrNull);
    updateSelectedTimezone(AppConstants.constant.globalRef?.read(countryListController).countryTimeZoneList.where((timezone) => timezone == destinationData.timeZone).firstOrNull);
    selectedDestinationType = AppConstants.constant.globalRef
        ?.read(destinationTypeListController)
        .destinationTypeList
        .where((destinationType) => destinationType.uuid == destinationData.destinationTypeUuid)
        .firstOrNull;

    AppConstants.constant.globalRef?.read(stateListController).getStateListAPI(context, countryUuid: destinationData.countryUuid,activeRecords: true,pageSize: AppConstants.pageSize10000).then((value) {
      updateSelectedState(AppConstants.constant.globalRef?.read(stateListController).stateList.where((state) => state.uuid == destinationData.stateUuid).firstOrNull);
    });

    AppConstants.constant.globalRef?.read(cityListController).getCityListAPI(context, stateUuid: destinationData.stateUuid,activeRecords: true,pageSize: AppConstants.pageSize10000).then((value) {
      updateSelectedCity(AppConstants.constant.globalRef?.read(cityListController).cityList.where((city) => city.uuid == destinationData.cityUuid).firstOrNull);
    });
    List<LanguageModel> preFillValueDestinationList = [];
    for (var language in destinationData.destinationValues ?? []) {
      preFillValueDestinationList.add(LanguageModel(uuid: language.languageUuid ?? '', fieldValue: language.name ?? ''));
      destinationNameTextFields = DynamicLangFormManager.instance.getLanguageListModel(textFieldModel: preFillValueDestinationList);
    }
    destinationTimingsList = destinationData.destinationTimeValues ?? [];

    for(var destinationDays in destinationTimingsList){
      final daysEnum = getDestinationDayEnum(destinationDays.dayOfWeek??'');
      destinationDays.dayOfWeek = daysEnum?.text ?? destinationDays.dayOfWeek; /// set localization text from enum
    }

    selectDestinationTypeController.text = destinationData.destinationTypeName ?? '';
    addressCountryController.text = destinationData.countryName ?? '';
    addressStateController.text = destinationData.stateName ?? '';
    addressCityController.text = destinationData.cityName ?? '';
    addressTimeZoneController.text = destinationData.timeZone ?? '';
    notifyListeners();
  }

  updateCountryDropdown(CountryModel? selectedCountry){
    this.selectedCountry = selectedCountry;
    addressCountryController.text = selectedCountry?.name ?? '';
    notifyListeners();
  }


  updateSelectedState(StateModel? selectedState) {
    this.selectedState = selectedState;
    addressStateController.text = selectedState?.name ?? '';
    notifyListeners();
  }

  CityModel? selectedCity;

  updateSelectedCity(CityModel? selectedCity) {
    this.selectedCity = selectedCity;
    addressCityController.text = selectedCity?.name ?? '';
    notifyListeners();
  }

  String? selectedTimeZone;

  updateSelectedTimezone(String? selectedTimeZone) {
    this.selectedTimeZone = selectedTimeZone;
    addressTimeZoneController.text = selectedTimeZone ?? '';
    notifyListeners();
  }

  DestinationType? selectedDestinationType;

  bool isPasswordVisible = false;

  updateIsPasswordVisible(bool isPasswordVisible) {
    this.isPasswordVisible = isPasswordVisible;
    notifyListeners();
  }

  bool isOwnerPasswordVisible = false;

  updateIsOwnerPasswordVisible(bool isOwnerPasswordVisible) {
    this.isOwnerPasswordVisible = isOwnerPasswordVisible;
    notifyListeners();
  }

  bool isPasscodeVisible = false;

  updateIsPasscodeVisible(bool isPasscodeVisible) {
    this.isPasscodeVisible = isPasscodeVisible;
    notifyListeners();
  }

  List<DestinationTimeValue> destinationTimingsList = [];
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keyMonday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keyTuesday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keyWednesday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keyThursday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keyFriday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keySaturday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  //   DestinationTimeValue(dayOfWeek: LocaleKeys.keySunday.localized, startHour: TimeOfDay(hour: 10, minute: 0).convertToDateTime, endHour: TimeOfDay(hour: 19, minute: 0).convertToDateTime),
  // ];

  DateTime? parseTimeStringToDateTime(String? timeStr) {
    if (timeStr == null) return null;

    try {
      final clean = timeStr.trim().replaceAll('\u00A0', ' ');
      return DateFormat('HH:mm:ss').parse(clean);
    } catch (e) {
      AppConstants.constant.showLog('Time parse error: $e');
      return null;
    }
  }

  bool? isSelectedTimeValid(DateTime selectedTime, String? startTimeString) {
    final parsedStart = parseTimeStringToDateTime(startTimeString);
    if (parsedStart == null) return true;

    final selected = DateTime(0, 1, 1, selectedTime.hour, selectedTime.minute);
    final start = DateTime(0, 1, 1, parsedStart.hour, parsedStart.minute);

    return selected.isAfter(start);
  }

  bool? isStartBeforeEnd(DateTime? selectedTime, String? endTimeString) {
    if (selectedTime == null) return null;

    final parsedEnd = parseTimeStringToDateTime(endTimeString);
    if (parsedEnd == null) return true;

    final selected = DateTime(0, 1, 1, selectedTime.hour, selectedTime.minute);
    final end = DateTime(0, 1, 1, parsedEnd.hour, parsedEnd.minute);

    return selected.isBefore(end);
  }

  int? applyToAllDaysIndex;
  updateApplyToAllDaysIndex(int index){
    applyToAllDaysIndex = index;
  }

  bool get isApplyToAllDaysShow {
    if(applyToAllDaysIndex == null || applyToAllDaysIndex == -1) return false;
    if(destinationTimingsList[applyToAllDaysIndex!].startHour != null && destinationTimingsList[applyToAllDaysIndex!].endHour != null){
      return true;
    }else{
      return false;
    }
  }

  setApplyToAllDaysTime(){
    for(var destinationTime in destinationTimingsList){
      destinationTime.startHour = destinationTimingsList[applyToAllDaysIndex!].startHour;
      destinationTime.endHour = destinationTimingsList[applyToAllDaysIndex!].endHour;
    }
    notifyListeners();
  }

  bool checkDestinationTimeValidation(){
    return destinationTimingsList.every((e) {
      return e.startHour != null && e.endHour != null;
    });
  }

  Uint8List? destinationImage;

  List<LanguageModel> destinationNameTextFields = [];

  /// Get LanguageList Model
  void getLanguageListModel(bool? isEdit) {
    destinationNameTextFields = DynamicLangFormManager.instance.getLanguageListModel(textFieldModel: null);
    notifyListeners();
  }

  /// Destination List API
  var manageDestinationState = UIState<DestinationDetailsMultiLanguageResponseModel>();

  Future<void> manageDestinationApi(BuildContext context, {String? destinationUuid}) async {
    manageDestinationState.isLoading = true;
    manageDestinationState.success = null;
    notifyListeners();
    List<Map<String, dynamic>> destinationNameValues = destinationNameTextFields.map((lang) {
      return {'languageUuid': lang.uuid, 'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''};
    }).toList();
    ManageDestinationRequestModel manageDestinationRequestModel = ManageDestinationRequestModel(
      destinationUuid: destinationUuid,
      destinationTypeUuid: selectedDestinationType?.uuid,
      totalFloor: int.parse(numberOfFloorController.text),
      passcode: passcodeController.text,
      ownerName: ownerNameController.text,
      email: ownerEmailIdController.text,
      contactNumber: ownerContactController.text,
      password: ownerPasswordController.text,
      houseNumber: addressHouseNumberController.text,
      streetName: addressStreetNameController.text,
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      landmark: addressLandmarkController.text,
      postalCode: addressPostalCodeController.text,
      countryUuid: selectedCountry?.uuid,
      stateUuid: selectedState?.uuid,
      cityUuid: selectedCity?.uuid,
      timeZone: addressTimeZoneController.text,
      premiumPrice: premiumPriceController.text,
      fillerPrice: fillerPriceController.text,
      destinationTimeValues: destinationTimingsList,
      destinationValues: destinationNameValues,
    );
    final result = await destinationDetailsRepository.manageDestinationApi(manageDestinationRequestModel.toString(), destinationUuid: destinationUuid);
    result.when(
      success: (data) async {
        manageDestinationState.success = data;
        if (manageDestinationState.success?.status == ApiEndPoints.apiStatus_200) {
          if (destinationImage != null) {
            FormData formData = FormData.fromMap({
              'file': MultipartFile.fromBytes(destinationImage?.toList() ?? [], filename: '${DateTime.now().millisecondsSinceEpoch}.jpeg', contentType: MediaType('image', 'jpeg')),
            });
            final result = await destinationDetailsRepository.uploadDestinationImageApi(formData, manageDestinationState.success?.data?.uuid ?? destinationDetailsState.success?.data?.uuid ?? '');
            result.when(
              success: (data) {
                manageDestinationState.isLoading = false;
                notifyListeners();

                ///Success Handling
                AppConstants.constant.globalRef
                    ?.read(destinationDetailsController)
                    .destinationDetailsApi(context, manageDestinationState.success?.data?.uuid ?? destinationDetailsState.success?.data?.uuid ?? '');
                AppConstants.constant.globalRef?.read(navigationStackController).pop();
              },
              failure: (error) {
                manageDestinationState.isLoading = false;
                notifyListeners();
              },
            );
          } else {
            manageDestinationState.isLoading = false;
            AppConstants.constant.globalRef
                ?.read(destinationDetailsController)
                .destinationDetailsApi(context, manageDestinationState.success?.data?.uuid ?? destinationDetailsState.success?.data?.uuid ?? '');
            AppConstants.constant.globalRef?.read(navigationStackController).pop();
          }
        }
      },
      failure: (NetworkExceptions error) {
        manageDestinationState.isLoading = false;
        notifyListeners();
      },
    );
  }

  /// destination details API
  var destinationDetailsState = UIState<DestinationDetailsMultiLanguageResponseModel>();

  Future<void> destinationDetailsApi(BuildContext context, String destinationUUid) async {
    destinationDetailsState.isLoading = true;
    destinationDetailsState.success = null;
    notifyListeners();

    final result = await destinationDetailsRepository.getDestinationDetailsMultiLanguageApi(destinationUUid);
    result.when(
      success: (data) async {
        destinationDetailsState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    destinationDetailsState.isLoading = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

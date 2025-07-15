import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/company/contract/company_repository.dart';
import 'package:odigov3/framework/repository/company/model/company_details_response_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/repository/company/model/company_update_request_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';
import 'package:path/path.dart' as path;


final companyController = ChangeNotifierProvider(
  (ref) => getIt<CompanyController>(),
);

@injectable
class CompanyController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    companyDetailState.success = null;
    companyDetailState.isLoading = true;
    mobileNumberController.text = '';
    emailController.text = '';
    gstNoController.text = '';
    cityController.text = '';
    stateController.text = '';
    customerEmailController.text = '';
    Future.delayed(const Duration(milliseconds: 50), () {
      editCompanyFormKey.currentState?.reset();
    });
    if (isNotify) {
      notifyListeners();
    }
  }

  FocusNode mobileNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode customerEmailFocusNode = FocusNode();
  FocusNode gstNoFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();

  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController gstNoController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController openingTimeController = TextEditingController();
  final TextEditingController closingTimeController = TextEditingController();

  String startTime = '';
  String endTime = '';

  GlobalKey<FormState> editCompanyFormKey = GlobalKey<FormState>();

  /// For uploading a single image
  Uint8List? selectedImage;
  String? documentName;
  String? documentSize;
  bool isImageErrorVisible = false;

  Future<String?> pickImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result?.xFiles.isNotEmpty ?? false) {
      final file = result?.xFiles.first;
      if (file == null) return null;
      final extension = path.extension(file.name).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].contains(extension)) {
        /// allowed only this extension
        if (result != null && result.files.isNotEmpty) {
          final pickedFile = result.files.first;
          selectedImage = pickedFile.bytes;

          final fileSizeInBytes = pickedFile.size;
          documentSize = formatBytes(fileSizeInBytes);

          final extension = pickedFile.extension ?? 'jpg';
          final today = DateTime.now();
          final formattedDate =
              "${today.day.toString().padLeft(2, '0')}-${today.month.toString()
              .padLeft(2, '0')}-${today.year}";
          documentName = 'company_image_$formattedDate.$extension';
          notifyListeners();
        }
      } else {
        context.showSnackBar(LocaleKeys.keyOnlyAllowedMessage.localized);
      }


    }

    return null;
  }

  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void removeImage() {
    selectedImage = null;
    documentName = null;
    documentSize = null;
    companyDetailState.success?.data?.imageName = null;
    notifyListeners();
  }

  ///change visibility of the is Image Error Visible
  void changeImageErrorVisible(bool isImageErrorVisible) {
    this.isImageErrorVisible = isImageErrorVisible;
    notifyListeners();
  }

  /// dynamic name field
  List<LanguageModel> listForTextField = [];
  List<LanguageModel>? languageModel;

  /// dynamic address field
  List<LanguageModel> listForAddressTextField = [];
  List<LanguageModel>? languageAddressModel;

  /// Get LanguageList Model
  void getLanguageListModel() {
    listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
      textFieldModel: languageModel,
    );
    listForAddressTextField = DynamicLangFormManager.instance
        .getLanguageListModel(textFieldModel: languageAddressModel);
    notifyListeners();
  }


  ///formatting timing
  String formatTime(String from) {
    if (from == null || from.isEmpty) {
      return '';
    }

    try {
      final inputFormat = DateFormat('HH:mm:ss.SSS');
      final outputFormat = DateFormat('h:mm a');

      final fromTime = inputFormat.parse(from);

      return outputFormat.format(fromTime);
    } catch (e) {
      return 'Invalid time format';
    }
  }

  ///update start time
  void updateStartTime(String value){
    openingTimeController.text = value;
    notifyListeners();
  }

  ///update end time
  void updateEndTime(String value){
    closingTimeController.text = value;
    notifyListeners();
  }

  DateTime? parseTimeStringToDateTime(String? timeStr) {
    if (timeStr == null) return null;

    try {
      final clean = timeStr.trim().replaceAll('\u00A0', ' ');
      return DateFormat('hh:mm a').parse(clean.toUpperCase());
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

  //--------------------- Api integration -------------------------//

  CompanyRepository companyRepository;

  CompanyController(this.companyRepository);

  var companyDetailState = UIState<CompanyDetailsResponseModel>();

  String openTime = '';
  String closeTime = '';
  String companyImage = '';

  ///get company detail api
  Future<void> getCompanyDetail(BuildContext context) async {
    companyDetailState.isLoading = true;
    companyDetailState.success = null;
    notifyListeners();

    final result = await companyRepository.getCompanyDetail();
    result.when(
      success: (data) async {
        companyDetailState.success = data;
        languageModel = [];
        languageAddressModel = [];
        for (CompanyValue? item
            in (companyDetailState.success?.data?.companyValues ?? [])) {
          languageModel?.add(
            LanguageModel(
              uuid: item?.languageUuid,
              name: item?.languageName,
              fieldValue: item?.companyName,
            ),
          );
          languageAddressModel?.add(
            LanguageModel(
              uuid: item?.languageUuid,
              name: item?.languageName,
              fieldValue: item?.companyAddress,
            ),
          );
        }
        if (companyDetailState.success?.data?.imageName != null) {
          documentName = companyDetailState.success?.data?.imageName
              ?.split('?')
              .first
              .split('/')
              .last;
        }
        mobileNumberController.text =
            companyDetailState.success?.data?.companyContact ?? '';
        gstNoController.text = companyDetailState.success?.data?.gstNo ?? '';
        emailController.text =
            companyDetailState.success?.data?.companyEmail ?? '';
        customerEmailController.text =
            companyDetailState.success?.data?.customerCareEmail ?? '';
        cityController.text = companyDetailState.success?.data?.cityName ?? '';
        stateController.text = companyDetailState.success?.data?.stateName ?? '';
        openingTimeController.text = formatTime(companyDetailState.success?.data?.openingHoursFrom ?? '');
        closingTimeController.text = formatTime(companyDetailState.success?.data?.openingHoursTo ?? '');
        openTime = openingTimeController.text;
        closeTime = closingTimeController.text;
        companyImage = companyDetailState.success?.data?.imageName ?? '';
      },
      failure: (NetworkExceptions error) {},
    );
    companyDetailState.isLoading = false;
    notifyListeners();
  }

  /// api call
  Future<void> editCompanyApiCall(BuildContext context, WidgetRef ref) async {
    changeImageErrorVisible(
      (selectedImage == null) &&
          companyDetailState.success?.data?.imageName == null,
    );
    if (editCompanyFormKey.currentState?.validate() == true &&
        !isImageErrorVisible) {
      await editCompanyApi(context);
      if (editCompanyState.success?.status == ApiEndPoints.apiStatus_200) {
        if (selectedImage != null) {
          await uploadCompanyImageApi(
            context,
            uuid: (companyDetailState.success?.data?.uuid ?? ''),
          );
          if (uploadCompanyImageState.success?.status ==
              ApiEndPoints.apiStatus_200) {
            Navigator.of(context).pop();
            getCompanyDetail(context);
          }
        } else {
          Navigator.of(context).pop();
          getCompanyDetail(context);
        }
      }
    }
  }

  ///-----------------  Edit Company Api------------------------------->
  UIState<CompanyDetailsResponseModel> editCompanyState =
      UIState<CompanyDetailsResponseModel>();

  Future<void> editCompanyApi(
    BuildContext context) async {
    editCompanyState.isLoading = true;
    editCompanyState.success = null;
    notifyListeners();

    List<CompanyRequestValue> companyNameValues = [];

    for (int i = 0; i < listForTextField.length; i++) {
      final langCompany = listForTextField[i];
      final langAddress = listForAddressTextField[i];

      companyNameValues.add(
        CompanyRequestValue(
          languageUuid: langCompany.uuid, // or langAddress.uuid, if same
          companyName:
              langCompany.textEditingController?.text ??
              langCompany.fieldValue ??
              '',
          companyAddress:
              langAddress.textEditingController?.text ??
              langAddress.fieldValue ??
              '',
        ),
      );
    }

    CompanyUpdateRequestModel editCompanyRequestModel =
        CompanyUpdateRequestModel(
          uuid: companyDetailState.success?.data?.uuid,
          companyValues: companyNameValues,
          gstNo: gstNoController.text,
          companyContact: mobileNumberController.text,
          companyEmail: emailController.text,
          customerCareEmail: customerEmailController.text,
          openingHoursFrom: formatTimeInPm(openingTimeController.text),
          openingHoursTo: formatTimeInPm(closingTimeController.text),
          stateName: stateController.text,
          cityName: cityController.text
        );
    String request = companyUpdateRequestModelToJson(editCompanyRequestModel);

    final result = await companyRepository.editCompanyApi(request);

    result.when(
      success: (data) async {
        editCompanyState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    editCompanyState.isLoading = false;
    notifyListeners();
  }

  ///----------------- Upload Image Api------------------------------->
  UIState<CommonResponseModel> uploadCompanyImageState =
      UIState<CommonResponseModel>();

  Future<void> uploadCompanyImageApi(
    BuildContext context, {
    required String uuid,
  }) async {
    if (selectedImage != null) {
      uploadCompanyImageState.isLoading = true;
      uploadCompanyImageState.success = null;
      notifyListeners();

      FormData? formData;
      MultipartFile companyPic = MultipartFile.fromBytes(
        selectedImage!,
        filename: documentName,
        contentType: MediaType('image', 'jpeg'),
      );
      formData = FormData.fromMap({'file': companyPic});

      final result = await companyRepository.uploadCompanyImage(formData, uuid);
      result.when(
        success: (data) async {
          uploadCompanyImageState.success = data;
        },
        failure: (NetworkExceptions error) {},
      );

      uploadCompanyImageState.isLoading = false;
      notifyListeners();
    }
  }



// Function for formatting closing time
  String formatTimeInPm(String closing) {
    try {
      // Trim any leading or trailing whitespace
      closing = closing.trim();

      // Check the time format and adjust accordingly
      final regExp = RegExp(r'(\d{1,2}):(\d{2})\s?(am|pm)', caseSensitive: false);
      final match = regExp.firstMatch(closing);

      if (match == null) {
        throw FormatException();
      }

      // Extract hours, minutes, and am/pm
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!.toLowerCase();

      // Convert to 24-hour format
      if (period == 'pm' && hour < 12) {
        hour += 12;  // Convert PM to 24-hour format
      }
      if (period == 'am' && hour == 12) {
        hour = 0;  // Midnight case
      }

      // Create a DateTime object
      final now = DateTime.now();
      final closingDateTime = DateTime(now.year, now.month, now.day, hour, minute);

      // Format the time as 'HH:mm:ss.SSS'
      final outputFormat = DateFormat('HH:mm:ss.SSS');
      final closingFormatted = outputFormat.format(closingDateTime);

      return closingFormatted;
    } catch (e) {
      print('Error parsing closing time: $e');
      return '';  // Return empty string if parsing fails
    }
  }
}

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client/contract/client_repository.dart';
import 'package:odigov3/framework/repository/client/model/request/add_client_request_model.dart';
import 'package:odigov3/framework/repository/client/model/request/delete_document_request_model.dart';
import 'package:odigov3/framework/repository/client/model/request/update_client_request_model.dart';
import 'package:odigov3/framework/repository/client/model/response/add_client_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_details_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/get_document_by_uuid_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/city/model/city_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:path/path.dart' as path;

final addUpdateClientController = ChangeNotifierProvider((ref) => getIt<AddUpdateClientController>());

@injectable
class AddUpdateClientController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      addUpdateClientFromKey.currentState?.reset();
    });
    pageNo = 1;
    deleteIndex = null;

    /// Clear Form Data
    clearFormData();
    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey documentViewKey = GlobalKey();
  FocusNode nameFocusNode = FocusNode();
  FocusNode mobileNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode pinCodeFocusNode = FocusNode();
  FocusNode documentNameFocusNode = FocusNode();
  FocusNode uploadImageFocusNode = FocusNode();
  FocusNode houseNumberFocusNode = FocusNode();
  FocusNode streetNameFocusNode = FocusNode();
  FocusNode addressLine1FocusNode = FocusNode();
  FocusNode addressLine2FocusNode = FocusNode();
  FocusNode landmarkFocusNode = FocusNode();
  FocusNode cityUuidFocusNode = FocusNode();
  FocusNode stateUuidFocusNode = FocusNode();
  FocusNode countryUuidFocusNode = FocusNode();
  FocusNode postalCodeFocusNode = FocusNode();

  final addUpdateClientFromKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController uploadImageController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityUuidController = TextEditingController();
  final TextEditingController stateUuidController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  CountryModel? selectedCountry;

  updateCountryDropdown(CountryModel? value){
    selectedCountry = value;
    notifyListeners();
  }


  StateModel? selectedState;

  updateSelectedState(StateModel? selectedState) {
    this.selectedState = selectedState;
    stateUuidController.text = selectedState?.name ?? '';
    cityUuidController.text = '';
    notifyListeners();
  }

  CityModel? selectedCity;

  updateSelectedCity(CityModel? selectedCity) {
    this.selectedCity = selectedCity;
    cityUuidController.text = selectedCity?.name ?? '';
    notifyListeners();
  }

  List<Uint8List> selectedImages = [];
  List<String> documentNames = [];
  List<String> documentSizes = [];
  List<Uint8List> selectedImagesEdit = [];
  List<String> documentNamesEdit = [];
  List<String> documentSizesEdit = [];

  /// To Pick Image
  Future<String?> pickImage() async {
    if (documentNameController.text
        .trim()
        .isEmpty) {
      return 'Please enter a document name first';
    }

    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;

      // --- Start of new validation logic ---
      if (pickedFile.bytes == null) {
        return 'Failed to read image data.'; // Or handle as appropriate
      }

      final fileExtension = path.extension(pickedFile.name).toLowerCase();
      final allowedExtensions = ['.jpg', '.jpeg', '.png'];

      if (!allowedExtensions.contains(fileExtension)) {
        return LocaleKeys.keyOnlyAllowedMessage.localized; // Use your localized message for disallowed types
      }
      // --- End of new validation logic ---

      final fileSizeInBytes = pickedFile.size;
      final readableSize = formatBytes(fileSizeInBytes);

      // The 'extension' variable here will now correctly reflect the validated extension
      // We can directly use pickedFile.extension as it would have been validated
      final extension = pickedFile.extension ??
          'jpg'; // Fallback to 'jpg' if somehow null, though validation should prevent this for images.
      final fullName = '${documentNameController.text.trim()}.$extension';

      selectedImages.add(pickedFile.bytes!);
      documentNames.add(fullName);
      documentSizes.add(readableSize);

      changeIsAddMoreVisibility(isAddMore: true);
      changeImageErrorVisible(false);
      notifyListeners();
    }

    return null;
  }

  /// To Pick Image Edit
  Future<String?> pickImageEdit({required BuildContext context, required String documentName, required String documentUuid, required String clientUuid}) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);

    if (result == null || result.files.isEmpty || result.files.first.bytes == null) {
      return 'No image selected';
    }

    final pickedFile = result.files.first;
    final fileBytes = pickedFile.bytes!;
    final fileSizeInBytes = pickedFile.size;
    final readableSize = formatBytes(fileSizeInBytes);
    final extension = pickedFile.extension ?? 'jpg';
    final fullName = documentName;

    // Add image data
    selectedImagesEdit.add(fileBytes);
    documentNamesEdit.add(fullName);
    documentSizesEdit.add(readableSize);

    // Upload image
    await updateDocumentImageApi(context, nameOfDocument: fullName, uuid: documentUuid);

    if (getDocumentByUuidState.success?.status == ApiEndPoints.apiStatus_200) {
      await getDocumentImageByUuidApi(context, clientUuid);
    }

    changeIsAddMoreVisibility(isAddMore: true);
    notifyListeners();

    return null; // Success
  }

  /// TO Format Bytes
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// To Remove Image
  void removeImage(int index) {
    if (index < selectedImages.length) {
      selectedImages.removeAt(index);
      documentNames.removeAt(index);
      documentSizes.removeAt(index);

      if (selectedImages.isEmpty) {
        changeIsAddMoreVisibility(isAddMore: false);
      }

      notifyListeners();
    }
  }

  /// To Remove Image Edit
  void removeImageEdit(int index) {
    if (index < selectedImagesEdit.length) {
      selectedImagesEdit.removeAt(index);
      documentNamesEdit.removeAt(index);
      documentSizesEdit.removeAt(index);

      if (selectedImagesEdit.isEmpty) {
        changeIsAddMoreVisibility(isAddMore: false);
      }

      notifyListeners();
    }
  }

  bool isAddMore = false;
  bool isImageErrorVisible = false;

  ///change visibility of the is Add More
  void changeIsAddMoreVisibility({required bool isAddMore}) {
    this.isAddMore = isAddMore;
    notifyListeners();
  }

  ///change visibility of the is Image Error Visible
  void changeImageErrorVisible(bool isImageErrorVisible) {
    this.isImageErrorVisible = isImageErrorVisible;
    notifyListeners();
  }

  int pageNo = 1;

  /// To Fill Data On Details And Edit
  fillDataOnDetails(BuildContext context, ClientDetailsData clientData) {
    nameController.text = clientData.name ?? '';
    emailController.text = clientData.email ?? '';
    mobileNumberController.text = clientData.contactNumber ?? '';
    houseNumberController.text = clientData.houseNumber ?? '';
    streetNameController.text = clientData.streetName ?? '';
    countryController.text = clientData.countryName ?? '';
    stateUuidController.text = clientData.stateName ?? '';
    cityUuidController.text = clientData.cityName ?? '';
    addressLine1Controller.text = clientData.addressLine1 ?? '';
    addressLine2Controller.text = clientData.addressLine2 ?? '';
    landmarkController.text = clientData.landmark ?? '';
    postalCodeController.text = clientData.postalCode ?? '';
    notifyListeners();
  }

  /// Clear Form Data
  void clearFormData() {
    nameController.clear();
    mobileNumberController.clear();
    emailController.clear();
    countryController.clear();
    cityController.clear();
    pinCodeController.clear();
    documentNameController.clear();
    uploadImageController.clear();
    houseNumberController.clear();
    streetNameController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    landmarkController.clear();
    cityUuidController.clear();
    stateUuidController.clear();
    countryController.clear();
    postalCodeController.clear();
    isImageErrorVisible = false;
    isAddMore = false;
    selectedCountry = null;
    selectedState = null;
    selectedCity = null;
    selectedImages.clear();
    documentNames.clear();
    documentSizes.clear();
    selectedImagesEdit.clear();
    documentNamesEdit.clear();
    documentSizesEdit.clear();
    documentsDataList.clear();
    deleteIndex = null;
    addNewClientApiState.isLoading = false;
    addNewClientApiState.success = null;
    updateClientApiState.isLoading = false;
    updateClientApiState.success = null;
    notifyListeners();
  }

  clearDocumentList({bool isNotify = false}){
    getDocumentByUuidState.isLoading = false;
    getDocumentByUuidState.success = null;
    documentsDataList.clear();
    if(isNotify) notifyListeners();
  }

  /// ================= Upload Document from client details ========== START ================================ ///

  /// Stores the currently selected or edited document data
  DocumentData? documentData;

  /// Prefills document data using a UUID, fetching from API if needed
  Future<void> setPrefillDocument(BuildContext context, String? documentUuid, String? clientUuid) async {
    if (documentsDataList.isNotEmpty) {
      /// If document data is already available, fetch directly
      documentData = documentsDataList.where((document) => document.uuid == documentUuid).firstOrNull;
      documentNameController.text = documentData?.name ?? '';
    } else {
      /// Otherwise, fetch from API and then filter
      await getDocumentImageByUuidApi(context, clientUuid ?? '');
      documentData = documentsDataList.where((document) => document.uuid == documentUuid).firstOrNull;
      documentNameController.text = documentData?.name ?? '';
    }
    notifyListeners(); // Notify UI about state update
  }

  /// Clears form data used for uploading a document
  void clearDocumentFormData({bool isNotify = false}) {
    addUpdateClientFromKey.currentState?.reset(); /// Resets the form
    selectedImages.clear(); /// Clears uploaded images
    documentNames.clear(); /// Clears stored names
    documentNameController.clear(); /// Clears name input field
    uploadDocumentImageState.success = null;
    uploadDocumentImageState.isLoading = false;
    updateDocumentImageState.isLoading = false;
    updateDocumentImageState.success = null;
    documentData = null;

    if (isNotify) notifyListeners();
  }

  /// Adds a new uploaded image to the list for adding a document
  void updateDocumentImage(Uint8List image) {
    selectedImages.add(image);
    notifyListeners();
  }

  /// Saves the current document name for the uploaded document
  void updateDocumentImageName() {
    documentNames.add(documentNameController.text);
    notifyListeners();
  }

  /// Moves the uploaded image to the editable list for editing existing documents
  void updateEditDocumentImage() {
    selectedImagesEdit.add(selectedImages.first);
    notifyListeners();
  }

  /// Saves the document name for the document being edited
  void updateEditDocumentImageName() {
    documentNamesEdit.add(documentNameController.text);
    notifyListeners();
  }

  /// Returns true if any document upload or update is currently in progress
  bool get isDocumentUploadLoading => uploadDocumentImageState.isLoading || updateDocumentImageState.isLoading;

  bool get isVisibleAddButton => (documentsDataList.length < 10 && !getDocumentByUuidState.isLoading);

  int? deleteIndex;
  updateDeleteIndex(int index){
    deleteIndex = index;
    notifyListeners();
  }

  /// ================= Upload Document from client details ========== END ================================== ///


  ClientRepository clientRepository;

  AddUpdateClientController(this.clientRepository);

  /// Add New Client Api
  UIState<AddClientResponseModel> addNewClientApiState = UIState<AddClientResponseModel>();

  Future<void> addClientApi(BuildContext context, WidgetRef ref) async {
    addNewClientApiState.isLoading = true;
    addNewClientApiState.success = null;
    notifyListeners();

    /// get Selected Assign Type Object and pass to

    final addClientRequestModel = AddClientRequestModel(
      name: nameController.text.trimSpace,
      email: emailController.text.trimSpace,
      contactNumber: mobileNumberController.text.trimSpace,
      houseNumber: houseNumberController.text.trimSpace,
      streetName: streetNameController.text.trimSpace,
      addressLine1: addressLine1Controller.text.trimSpace,
      addressLine2: addressLine2Controller.text.trimSpace,
      landmark: landmarkController.text.trimSpace,
      countryUuid: selectedCountry?.uuid,
      stateUuid: selectedState?.uuid,
      cityUuid: selectedCity?.uuid,
      postalCode: postalCodeController.text.trimSpace,
    );

    final result = await clientRepository.addClientApi(addClientRequestModelToJson(addClientRequestModel));
    result.when(
      success: (data) async {
        addNewClientApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );
    addNewClientApiState.isLoading = false;
    notifyListeners();
  }

  /// Update Client Api
  UIState<CommonResponseModel> updateClientApiState = UIState<CommonResponseModel>();

  Future<void> updateClientApi(BuildContext context, String uuid) async {
    updateClientApiState.isLoading = true;
    updateClientApiState.success = null;
    notifyListeners();

    final updateUserRequestModel = UpdateClientRequestModel(
      uuid: AppConstants.constant.globalRef?.read(clientDetailsController).clientDetailsState.success?.data?.uuid,
      name: nameController.text.trimSpace,
      email: emailController.text.trimSpace,
      contactNumber: mobileNumberController.text.trimSpace,
      houseNumber: houseNumberController.text.trimSpace,
      streetName: streetNameController.text.trimSpace,
      addressLine1: addressLine1Controller.text.trimSpace,
      addressLine2: addressLine2Controller.text.trimSpace,
      landmark: landmarkController.text.trimSpace,
      postalCode: postalCodeController.text.trimSpace,
    );

    final result = await clientRepository.updateClientApi(updateClientRequestModelToJson(updateUserRequestModel));
    result.when(
      success: (data) async {
        updateClientApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    updateClientApiState.isLoading = false;
    notifyListeners();
  }

  /// Upload document Image Api
  UIState<CommonResponseModel> uploadDocumentImageState = UIState<CommonResponseModel>();

  Future<void> uploadDocumentImageApi(BuildContext context, {required String uuid}) async {
    uploadDocumentImageState.isLoading = true;
    uploadDocumentImageState.success = null;
    notifyListeners();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      /// Detect MIME type using the first image
      Uint8List firstImageBytes = selectedImages.first;
      String? mimeType = lookupMimeType('', headerBytes: firstImageBytes);
      String extension = mimeType?.split('/').last ?? 'jpeg';

      /// Ensure supported formats
      List<String> allowedExtensions = ['jpeg', 'jpg', 'png' /*, 'heif', 'heic'*/];
      if (!allowedExtensions.contains(extension)) {
        showErrorDialogue(context: context, animation: Assets.anim.animErrorJson.keyName, successMessage: 'Unsupported file format');
        uploadDocumentImageState.isLoading = false;
        notifyListeners();
        return;
      }

      /// Build image map for uploading
      Map<String, dynamic> imagesMap = {};

      for (int i = 0; i < selectedImages.length; i++) {
        MultipartFile documentPic = MultipartFile.fromBytes(selectedImages[i], filename: '${DateTime.now().millisecondsSinceEpoch}_$i.$extension');

        imagesMap.addAll({'clientDocuments[$i].name': documentNames[i], 'clientDocuments[$i].file': documentPic});
      }

      imagesMap['clientUuid'] = uuid;

      FormData formData = FormData.fromMap(imagesMap);

      final result = await clientRepository.uploadDocumentImageApi(formData);

      result.when(
        success: (data) async {
          uploadDocumentImageState.success = data;
        },
        failure: (NetworkExceptions error) {
          // Handle error if needed
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        },
      );
    } else {
      showErrorDialogue(context: context, animation: Assets.anim.animErrorJson.keyName, successMessage: 'No image selected');
    }

    uploadDocumentImageState.isLoading = false;
    notifyListeners();
  }

  /// Update document Image Api
  UIState<CommonResponseModel> updateDocumentImageState = UIState<CommonResponseModel>();

  Future<void> updateDocumentImageApi(BuildContext context, {required String nameOfDocument, required String uuid}) async {
    uploadDocumentImageState.isLoading = true;
    uploadDocumentImageState.success = null;
    notifyListeners();

    // Check if image is selected
    if (selectedImagesEdit != null && selectedImagesEdit.isNotEmpty && documentNamesEdit.isNotEmpty) {
      final Uint8List documentBytes = selectedImagesEdit.first;
      final String documentName = documentNamesEdit.first;

      // Detect MIME type safely
      String? mimeType = lookupMimeType('', headerBytes: documentBytes);
      String extension = mimeType?.split('/').last ?? 'jpeg';

      // Supported file types
      List<String> allowedExtensions = ['jpeg', 'jpg', 'png'];
      if (!allowedExtensions.contains(extension)) {
        showErrorDialogue(context: context, animation: Assets.anim.animErrorJson.keyName, successMessage: 'Unsupported file format');
        uploadDocumentImageState.isLoading = false;
        notifyListeners();
        return;
      }

      // Create multipart file
      final MultipartFile documentFile = MultipartFile.fromBytes(documentBytes, filename: '${documentName}.${extension}');

      final formData = FormData.fromMap({'uuid': uuid, 'name': nameOfDocument, 'file': documentFile});

      // Call API
      final result = await clientRepository.updateDocumentImageApi(formData);
      result.when(
        success: (data) async {
          uploadDocumentImageState.success = data;

          selectedImagesEdit.clear();
          documentNamesEdit.clear();
        },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        },
      );
    } else {
      showErrorDialogue(context: context, animation: Assets.anim.animErrorJson.keyName, successMessage: 'No image selected');
    }

    uploadDocumentImageState.isLoading = false;
    notifyListeners();
  }

  List<DocumentData> documentsDataList = [];

  /// Get Document By Uuid API
  UIState<GetDocumentByUuidModel> getDocumentByUuidState = UIState<GetDocumentByUuidModel>();

  Future<void> getDocumentImageByUuidApi(BuildContext context, String clientUuid) async {
    getDocumentByUuidState.isLoading = true;
    getDocumentByUuidState.success = null;
    documentsDataList.clear();
    notifyListeners();

    final result = await clientRepository.getDocumentImageByUuidApi(clientUuid);
    result.when(
      success: (data) async {
        getDocumentByUuidState.success = data;
        documentsDataList.addAll((getDocumentByUuidState.success?.data?.documents ?? []));
      },
      failure: (NetworkExceptions error) {},
    );

    getDocumentByUuidState.isLoading = false;
    notifyListeners();
  }

  /// Get Document By Uuid API
  UIState<CommonResponseModel> removeDocumentState = UIState<CommonResponseModel>();

  Future<void> removeDocumentApi(BuildContext context, String? imageUuid) async {
    removeDocumentState.isLoading = true;
    removeDocumentState.success = null;
    notifyListeners();

    final deleteDocumentRequestModel = DeleteDocumentRequestModel(uuidList: [imageUuid ?? '']);

    final result = await clientRepository.deleteDocumentImageApi(deleteDocumentRequestModelToJson(deleteDocumentRequestModel));
    result.when(
      success: (data) async {
        removeDocumentState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    removeDocumentState.isLoading = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

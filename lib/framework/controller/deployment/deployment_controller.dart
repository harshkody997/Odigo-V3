import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/deployment/contract/deployment_repository.dart';
import 'package:odigov3/framework/repository/deployment/model/deployment_list_request_model.dart';
import 'package:odigov3/framework/repository/deployment/model/deployment_list_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:path/path.dart' as path;


final deploymentController = ChangeNotifierProvider(
      (ref) => getIt<DeploymentController>(),
);

@injectable
class DeploymentController extends ChangeNotifier {
  DeploymentController(this.deploymentRepository);
  final DeploymentRepository deploymentRepository;


  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    deploymentListState.isLoading = true;
    deploymentListState.success = null;
    deployFormKey.currentState?.reset();
    deploymentList.clear();
    searchCtr.clear();
    selectDestinationCtr.clear();
    selectedFile = null;
    documentName = null;
    documentSize = null;
    isFileErrorVisible = false;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  disposeDeployment() {
    addDeploymentState.isLoading = false;
    notifyListeners();
  }

  void clearForm() {
    selectDestinationCtr.text = '';
    selectedFile = null;
    documentName = null;
    documentSize = null;
    isFileErrorVisible = false;
    versionNameController.text = '';
    deployFormKey.currentState?.reset();
    notifyListeners();
  }

  FocusNode destinationFocusNode = FocusNode();

  ///Version name and url controller
  final TextEditingController versionNameController = TextEditingController();
  TextEditingController selectDestinationCtr = TextEditingController();

  GlobalKey<FormState> deployFormKey = GlobalKey<FormState>();




  /// For uploading a single file
  Uint8List? selectedFile;
  String? documentName;
  String? documentSize;
  bool isFileErrorVisible = false;

  Future<String?> pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom,
        allowedExtensions:  ['apk'], withData: true);

    if (result?.xFiles.isNotEmpty ?? false) {
      final file = result?.xFiles.first;
      if(file == null) {
        return null;
      }

      final extension = path.extension(file.name).toLowerCase();
      if (['.apk'].contains(extension)) { /// allowed only this extension
        if (result != null && result.files.isNotEmpty) {
          final pickedFile = result.files.first;
          selectedFile = pickedFile.bytes;

          final fileSizeInBytes = pickedFile.size;
          documentSize = formatBytes(fileSizeInBytes);

          documentName = '${pickedFile.name}';
          notifyListeners();
        }
      } else {
        context.showSnackBar(LocaleKeys.keyOnlyApkAllowedMessage.localized);
      }
    }

    return null;
  }

  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void removeFile() {
    selectedFile = null;
    documentName = null;
    documentSize = null;
    notifyListeners();
  }

  ///change visibility of the is File Error Visible
  void changeFileErrorVisible(bool isFileErrorVisible) {
    this.isFileErrorVisible = isFileErrorVisible;
    notifyListeners();
  }

  /// Selected destination
  DestinationData? selectedDestination;

  updateSelectedDestination(DestinationData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    selectDestinationCtr.text = selectedDestination?.name ?? '';
    notifyListeners();
  }




  void notify(){
    notifyListeners();
  }

  /// Search Controller
  TextEditingController searchCtr = TextEditingController();

  /// Filter key
  GlobalKey filterKey = GlobalKey();


  CommonEnumTitleValueModel? selectedFilter = commonFilterStatusList[0];
  CommonEnumTitleValueModel? selectedTempFilter = commonFilterStatusList[0];
  updateTempSelectedStatus(CommonEnumTitleValueModel? value){
    selectedTempFilter = value;
    notifyListeners();
  }

  updateSelectedStatus(CommonEnumTitleValueModel? value){
    selectedFilter = value;
    notifyListeners();
  }

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]);

  bool get isFilterApplied => selectedFilter != null && selectedFilter != commonActiveDeActiveList[0];



  /// ----------------------------------------------- Api Integration ----------------------------------------------------///

  ///-----------------Deployment List Api------------------------------->
  var deploymentListState = UIState<DeploymentListResponseModel>();
  List<DeploymentList?> deploymentList =[];

  Future<UIState<DeploymentListResponseModel>> deploymentListApi(BuildContext context, {bool isForPagination = false, String? searchKeyword, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      deploymentList.clear();
      deploymentListState.isLoading = true;
      deploymentListState.success = null;
    }
    else if(deploymentListState.success?.hasNextPage ?? false){
      pageNo = (deploymentListState.success?.pageNumber ?? 0) + 1;
      deploymentListState.isLoadMore = true;
      deploymentListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      String request = deploymentListRequestModelToJson(DeploymentListRequestModel(
        searchKeyword: searchKeyword,
        buildStatus: selectedFilter?.enumType != null ? selectedFilter?.enumType : ''
      ));

      final result = await deploymentRepository.deploymentListApi(pageNo,request);

      result.when(success: (data) async {
        deploymentListState.success = data;
        deploymentList.addAll(deploymentListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
      });

      deploymentListState.isLoading = false;
      deploymentListState.isLoadMore = false;
      notifyListeners();
    }
    return deploymentListState;

  }

///Upload build api
  var addDeploymentState = UIState<CommonResponseModel>();

  Future<void> addNewDeploymentApi(BuildContext context) async {

    if (selectedFile != null) {
      addDeploymentState.success = null;
      addDeploymentState.isLoading = true;
      notifyListeners();


      FormData? formData;


        String mimeType;
        if (documentName!.endsWith('.apk')) {
          mimeType = 'application/vnd.android.package-archive';
        } else {
          mimeType = 'application/octet-stream'; // Fallback for unknown types
        }

        MultipartFile deploymentFile = MultipartFile.fromBytes(selectedFile!,filename: documentName, contentType: MediaType.parse(mimeType));
        formData = FormData.fromMap({
          'buildFile' :deploymentFile,
          'destinationUuid' : selectedDestination?.uuid,
          'buildType' : 'DISPLAY',
          'version' : double.parse(versionNameController.text.trimSpace),
          'technology' : 'FLUTTER_APK',
        });




      final result = await deploymentRepository.addNewDeploymentApi(formData);
      result.when(success: (data) async {
        addDeploymentState.success = data;
        addDeploymentState.isLoading = false;

      }, failure: (NetworkExceptions error) {
      });
      addDeploymentState.isLoading = false;
      notifyListeners();
    }
  }
  /// api call
  Future<void> addDeploymentApiCall(BuildContext context, WidgetRef ref) async {
    changeFileErrorVisible((selectedFile == null));
    if (deployFormKey.currentState?.validate() == true && selectedDestination != null && !isFileErrorVisible) {
        if(selectedFile != null) {
          await addNewDeploymentApi(context);
          if(addDeploymentState.success?.status == ApiEndPoints.apiStatus_200){
            deploymentListApi(context);
            ref.read(navigationStackController).pop();
          }
        }
        else {
          deploymentListApi(context);
          ref.read(navigationStackController).pop();
        }

    }
  }


}


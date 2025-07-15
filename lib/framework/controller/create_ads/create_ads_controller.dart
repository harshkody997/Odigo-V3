
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client_ads/contract/client_ads_repository.dart';
import 'package:odigov3/framework/repository/client_ads/model/add_client_ads_response_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_details_response_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/request_model/add_client_ads_request_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/request_model/update_client_ads_request_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/contract/default_ads_repository.dart';
import 'package:odigov3/framework/repository/default_ads/model/add_default_ads_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_details_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/request_model/add_default_ads_request_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/request_model/update_default_ads_request_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/main.dart';
import 'package:odigov3/ui/ads_create/web/helper/trim_settings.dart';
import 'package:odigov3/ui/ads_create/web/helper/video_service.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:video_player/video_player.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

final createAdsController = ChangeNotifierProvider(
      (ref) => getIt<CreateAdsController>(),
);

@injectable
class CreateAdsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      formKey.currentState?.reset();
    });
    clearFormData();
    isLoading = false;

    selectedDocumentData = null;
    mediaIndex = 0;
    isVideoTrimming = false;
    selectedDocumentFile = null;
    documentName = '';
    documentSize = '';
    selectedClient = '';
    selectedDestination = '';
    selectedClientUuid = '';
    selectedDestinationUuid = '';
    listImages.clear();
    listVideos.clear();
    viewerDocumentData = null;
    tappedIndex = -1;
    if (isNotify) {
      notifyListeners();
    }
  }

  void clearFormData(){
    addTagNameController.clear();
    searchClientController.clear();
    searchDestinationController.clear();
    selectedClient = null;
    selectedClientUuid = null;
    selectedDestination = null;
    selectedDestinationUuid = null;
    selectedDocumentData = null;
    selectedDocumentFile = null;
    isImageErrorVisible = false;
    // notifyListeners();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;
  bool isVideoTrimming = false;
  void updateVideoTrimmerStatus(bool value){
    isVideoTrimming = value;
    notifyListeners();
  }

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }


  TextEditingController searchClientController = TextEditingController();
  TextEditingController searchDestinationController = TextEditingController();
  TextEditingController addTagNameController = TextEditingController();

  FocusNode tagFocus = FocusNode();

  String? selectedClient;
  String? selectedClientUuid;
  String? selectedDestination;
  String? selectedDestinationUuid;

  void updateClientDropdown(String value, String uuid) {
    selectedClient = value;
    selectedClientUuid = uuid;
    notifyListeners();
  }

  void updateDestinationDropdown(String value, String uuid) {
    selectedDestination = value;
    selectedDestinationUuid = uuid;
    notifyListeners();
  }

  int mediaIndex = 0;
  updateMediaIndex(int value){
    mediaIndex = value;
    notifyListeners();
  }

  /// On Ad Content Details
  void onAdContentDetails({ClientAdsDetailsData? clientAdsData, DefaultAdsDetailsData? defaultAdsData}){
    searchClientController.text = clientAdsData?.clientName ?? '';
    searchDestinationController.text = defaultAdsData?.destinationName ?? '';
    addTagNameController.text = (clientAdsData != null) ? clientAdsData.name ?? '' : defaultAdsData?.name ?? '';
    notifyListeners();
  }

  /// For uploading a Multi image
  List<DocumentData> listImages = [];

  List<DocumentData> listVideos = [];

  Uint8List? selectedDocumentData;
  File? selectedDocumentFile;
  String? documentName;
  String? documentSize;
  bool isImageErrorVisible = false;

  ///change visibility of the is Image Error Visible
  void changeImageErrorVisible(bool isImageErrorVisible) {
    this.isImageErrorVisible = isImageErrorVisible;
    notifyListeners();
  }

  Future<String?> pickImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final extension = pickedFile.extension?.toLowerCase();

      // Manual validation in case a different file slips through
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        showErrorDialogue(
          buttonText: LocaleKeys.keyOk.localized,
            onTap: (){
            Navigator.of(context).pop();
            },
            context: context,
            animation: Assets.anim.animErrorJson.keyName,
            successMessage: LocaleKeys.keyUploadImageValidationErrorMsg.localized);
        notifyListeners();
        return null;
      }

      selectedDocumentData = pickedFile.bytes;

      final fileSizeInBytes = pickedFile.size;
      documentSize = formatBytes(fileSizeInBytes);

      final today = DateTime.now();
      final formattedDate =
          "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";
      documentName =
      'ads_image_${listImages.length + 1}_$formattedDate.$extension';

      listImages.add(DocumentData(
        selectedData: selectedDocumentData,
        documentSize: documentSize,
        documentName: documentName,
        fileType: FileType.image,
      ));

      print(listImages.map((e) => e.documentName));
      print(listImages.map((e) => e.documentSize));

      changeImageErrorVisible(false);
      notifyListeners();
    }

    return null;
  }

  bool isVideoLoading = false;
  String? errorMessage;
  dynamic selectedVideoSource;
  Duration? videoDuration;

  TrimSettings? trimSettings;
  Duration currentPosition = Duration.zero;
  final VideoService _videoService = VideoService();

  GlobalKey videoTrimmerDialogKey = GlobalKey();


  VideoPlayerController? controller;
  bool isInitialized = false;
  bool isPlaying = false;

  updateInitialization(bool value){
      isInitialized = value;
      notifyListeners();
  }
  updateCurrentPosition(Duration value){
    currentPosition =value;
    notifyListeners();
  }
  updatePlayingStatus(bool value){
    isPlaying = value;
    notifyListeners();
  }

  Future<File?> selectVideo(BuildContext context) async {
    try {
      isVideoLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'mp4', 'mkv', 'avi', 'mov', 'flv', 'webm', 'mpeg', 'mpg', 'ogv'
        ],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = result.files.single;
        final extension = pickedFile.extension?.toLowerCase();

        // Validate selected extension
        const allowedExtensions = [
          'mp4', 'mkv', 'avi', 'mov', 'flv', 'webm', 'mpeg', 'mpg', 'ogv'
        ];

        if (extension == null || !allowedExtensions.contains(extension)) {
          showErrorDialogue(
            context: context,
            animation: Assets.anim.animErrorJson.keyName,
            successMessage: LocaleKeys.keyUploadVideoValidationErrorMsg.localized,
            buttonText: LocaleKeys.keyOk.localized,
            onTap: () {
              Navigator.of(context).pop();
            },
          );
          return null;
        }

        dynamic videoSource;
        if (kIsWeb) {
          if (pickedFile.path != null) {
            videoSource = pickedFile.path!;
          } else {
            errorMessage = 'Failed to load video file';
            notifyListeners();
            return null;
          }
        } else {
          videoSource = File(pickedFile.path!);
        }

        final duration = await _videoService.getVideoDuration(videoSource);
        if (duration == null) {
          errorMessage = AppConstants.errorVideoLoadFailed;
          notifyListeners();
          return null;
        }

        final fileSizeInBytes = pickedFile.size;
        documentSize = formatBytes(fileSizeInBytes);

        if (documentSize == null) {
          errorMessage = AppConstants.errorVideoLoadFailed;
          notifyListeners();
          return null;
        }

        selectedDocumentData = pickedFile.bytes;
        selectedDocumentFile = File(pickedFile.path ?? '');

        final today = DateTime.now();
        final formattedDate = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";
        documentName = 'ads_video_${listImages.length + 1}_$formattedDate.$extension';

        if (duration.inSeconds < AppConstants.minimumVideoDurationSeconds) {
          errorMessage = 'Video is ${_videoService.formatDuration(duration)} long. Videos must be at least ${AppConstants.minimumVideoDurationSeconds} seconds to trim.';
          notifyListeners();
          return null;
        }

        final canTrim = await _videoService.canTrimVideo(videoSource);
        if (!canTrim) {
          errorMessage = 'Cannot process this video. Please check the format and try again.';
          notifyListeners();
          return null;
        }

        final trim = TrimSettings.fromStartTime(
          videoFile: kIsWeb ? null : videoSource as File,
          videoUrl: kIsWeb ? videoSource as String : null,
          startTime: Duration.zero,
          trimDuration: const Duration(seconds: AppConstants.defaultTrimDurationSeconds),
          videoDuration: duration,
        );

        selectedVideoSource = videoSource;
        videoDuration = duration;
        trimSettings = trim;
        currentPosition = Duration.zero;

        listVideos.add(DocumentData(
          selectedFile: selectedDocumentFile,
          selectedData: selectedDocumentData,
          documentSize: documentSize,
          documentName: documentName,
          fileType: FileType.video,
        ));

        notifyListeners();
        return selectedDocumentFile;
      }
    } catch (e) {
      errorMessage = 'Error selecting video: $e';
      notifyListeners();
    } finally {
      isVideoLoading = false;
      notifyListeners();
    }

    return null;
  }

  void skipTrimmer(){
    showLog('createAdWatch.listVideos.length ${listVideos.length}');
    showLog('createAdWatch.listVideos.length ${listVideos.map((e) => e.documentName,)}');
    // listVideos.add(DocumentData(selectedFile: selectedDocumentFile,selectedData: selectedDocumentData,documentSize: documentSize,documentName: documentName,fileType: FileType.video));
    notifyListeners();

  }


  void onTrimChanged(Duration startTime) {
    if (videoDuration == null) return;

    final newTrimSettings = TrimSettings.fromStartTime(
      videoFile: kIsWeb ? null : selectedVideoSource as File,
      videoUrl: kIsWeb ? selectedVideoSource as String : null,
      startTime: startTime,
      trimDuration: const Duration(seconds: AppConstants.defaultTrimDurationSeconds),
      videoDuration: videoDuration!,
    );

    trimSettings = newTrimSettings;
    showLog('trimSettings trimSettings ${trimSettings?.startTime} || ${trimSettings?.endTime}');
    notifyListeners();
  }

  void onPositionChanged(Duration position) {
      currentPosition = position;
      showLog('ositionositionosition ${currentPosition}');
      notifyListeners();
  }


  void removeImage(int index) {
    listImages.removeAt(index);
    notifyListeners();
  }
  void removeVideo(int index) {
    showLog('listVideos ${listVideos.length}');
    showLog('listVideos ${index}');
    listVideos.removeAt(index);
    notifyListeners();
  }

  DocumentData? viewerDocumentData;
  int? tappedIndex;
  updateViewerData(DocumentData? value , int index){
    viewerDocumentData = value;
    tappedIndex = index;
    notifyListeners();
  }



  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }


  VideoPlayerController? videoController;
  File? _videoFile;

  Future<void> initialiseVideo({
    Uint8List? videoBytes,
    String? videoUrl,
  }) async {
    String blobUrl = '';
    if(videoBytes != null) {
      showLog('videoBytesvideoBytesvideoBytes ${videoBytes.first}');

      // For web: create a Blob URL
      final blob = html.Blob([videoBytes], 'video/mp4');
      blobUrl = html.Url.createObjectUrlFromBlob(blob);

      showLog('Web video URL: $blobUrl');
    }

    videoController = VideoPlayerController.network((videoBytes != null) ? blobUrl : videoUrl??'')
      ..setLooping(true)
      ..initialize().then((_) {
        notifyListeners();
        videoController?.play();
      });
    notifyListeners();
  }
  playPausePlayer(){
    if(videoController!.value.isPlaying) {
      videoController?.pause();
    }else{
      videoController?.play();
    }
    notifyListeners();
  }

  disposeVideo(){
    videoController?.dispose();
    notifyListeners();
  }

  // Future<void> initialize({File? videoFile, String? videoUrl, TrimSettings? trim}) async {
  //   trimSettings = trim;
  //   if (videoFile == null && videoUrl == null) {
  //     disposeController();
  //     return;
  //   }
  //
  //   try {
  //     disposeController();
  //
  //     if (videoUrl != null) {
  //       controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  //     } else if (videoFile != null) {
  //       controller = VideoPlayerController.file(videoFile);
  //     }
  //
  //     await controller!.initialize();
  //     controller!.addListener(_videoListener);
  //
  //     isInitialized = true;
  //     notifyListeners();
  //   } catch (e) {
  //     isInitialized = false;
  //     notifyListeners();
  //   }
  // }

  void _videoListener() {
    if (controller != null && controller!.value.isInitialized) {
      final position = controller!.value.position;
      if (position != currentPosition) {
        currentPosition = position;
        notifyListeners();
      }

      if (trimSettings != null && position >= trimSettings!.endTime) {
        controller!.pause();
        isPlaying = false;
        notifyListeners();
      }
    }
  }

  void disposeVideoController() {
    controller?.removeListener(_videoListener);
    controller?.dispose();
    controller = null;
    isInitialized = false;
    isPlaying = false;
    currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (controller == null || !controller!.value.isInitialized) return;

    if (isPlaying) {
      await controller!.pause();
    } else {
      if (trimSettings != null) {
        final currentPos = controller!.value.position;
        if (currentPos < trimSettings!.startTime || currentPos >= trimSettings!.endTime) {
          await controller!.seekTo(trimSettings!.startTime);
        }
      }
      await controller!.play();
    }

    isPlaying = !isPlaying;
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async {
    if (controller != null && controller!.value.isInitialized) {
      await controller!.seekTo(position);
    }
  }



  Future<void> trim() async {

    updateVideoTrimmerStatus(true);
    showLog('isVideoTrimming isVideoTrimming ${isVideoTrimming}');
    final response = await html.HttpRequest.request(
      selectedVideoSource!,
      responseType: 'blob',
    );
    final blob = response.response as html.Blob;

    showLog('Start: ${trimSettings!.startTime.inSeconds.toDouble()}');
    showLog('End: ${trimSettings!.endTime.inSeconds.toDouble()}');

    final Uint8List trimmedBytes = await js_util.promiseToFuture(
      trimVideoJS(
        blob,
        trimSettings!.startTime.inSeconds.toDouble(),
        trimSettings!.endTime.inSeconds.toDouble(),
      ),
    );

    Future.delayed(Duration(seconds: 2),() async {
      // Uint8List? dataBytes = await getFileFromBlobUrl(blobUrl);
      showLog('blobUrl blobUrl ${trimmedBytes}');
      if(trimmedBytes != null){
        // showLog('selectedDocumentFile ${selectedDocumentFile}');
        // showLog('documentSize ${documentSize}');
        // showLog('documentName ${documentName}');
        selectedDocumentData = trimmedBytes;
        documentSize = formatBytes(trimmedBytes.length);

        final extension = 'mp4';
        final today = DateTime.now();
        final formattedDate = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";
        documentName = 'ads_video_${listImages.length + 1}_$formattedDate.$extension';

        showLog('documentSize ${documentSize}');
        showLog('documentName ${documentName}');
        showLog('selectedDocumentData ${selectedDocumentData}');
        listVideos.add(DocumentData(selectedFile: selectedDocumentFile,selectedData:trimmedBytes,documentSize: documentSize,documentName: documentName,fileType: FileType.video));
        showLog('listVideos ${listVideos.map((e) => e.documentName,)}');
        showLog('listVideos ${listVideos.map((e) => e.selectedFile,)}');
        notifyListeners();
      }
    },);


    updateVideoTrimmerStatus(false);
    showLog('blobUrl: $trimmedBytes');
    // Use blobUrl for video preview or download
  }


  Future<Uint8List> getFileFromBlobUrl(String blobUrl) async {
    final response = await html.HttpRequest.request(
      blobUrl,
      responseType: 'blob',
    );

    final blob = response.response as html.Blob;

    // Convert Blob to bytes
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((event) {
      final result = reader.result as ByteBuffer;
      completer.complete(result.asUint8List());
    });

    return completer.future;
  }



/*
  /// ---------------------------- Create Default Ads Api Integration ---------------------------------///
   */
  DefaultAdsRepository defaultAdsRepository;
  ClientAdsRepository clientApiRepository;

  CreateAdsController(this.defaultAdsRepository, this.clientApiRepository);

  /// Add Default Add API
  UIState<AddDefaultAdsResponseModel> addDefaultAdApiState = UIState<AddDefaultAdsResponseModel>();

  Future<void> addDefaultAdsApi(BuildContext context, WidgetRef ref) async {
    addDefaultAdApiState.isLoading = true;
    addDefaultAdApiState.success = null;
    notifyListeners();

    final addDefaultAdsRequestModel = AddDefaultAdsRequestModel(
      destinationUuid: selectedDestinationUuid,
      name: addTagNameController.text,
      adsMediaType: mediaIndex == 0 ? 'IMAGE' : 'VIDEO',
    );

    final result = await defaultAdsRepository.addDefaultAdsApi(request: addDefaultAdsRequestModelToJson(addDefaultAdsRequestModel));
    result.when(
      success: (data) async {
        addDefaultAdApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );
    addDefaultAdApiState.isLoading = false;
    notifyListeners();
  }

  /// Update Default Add Name API
  UIState<CommonResponseModel> updateDefaultAdsNameApiState = UIState<CommonResponseModel>();

  Future<void> updateDefaultAdNameApi(BuildContext context, String uuid) async {
    updateDefaultAdsNameApiState.isLoading = true;
    updateDefaultAdsNameApiState.success = null;
    notifyListeners();

    final updateDefaultAdsRequestModel = UpdateDefaultAdsRequestModel(
      uuid: uuid,
      name: addTagNameController.text

    );

    final result = await defaultAdsRepository.updateDefaultAdsNameApi(request: updateDefaultAdsRequestModelToJson(updateDefaultAdsRequestModel));
    result.when(
      success: (data) async {
        updateDefaultAdsNameApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    updateDefaultAdsNameApiState.isLoading = false;
    notifyListeners();
  }

  /// Upload Ads Add Image Content
  UIState<CommonResponseModel> addDefaultAdsContentImageState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> addDefaultAdsContentImageApi(BuildContext context, {required String defaultAdsUuid}) async {
    if (listImages.isNotEmpty) {
      addDefaultAdsContentImageState.isLoading = true;
      addDefaultAdsContentImageState.success = null;
      notifyListeners();

      try {
        List<MultipartFile> files = [];

        for (var image in listImages) {
          if (image.selectedData != null) {
            final multipartFile = MultipartFile.fromBytes(
              image.selectedData!,
              filename: image.documentName,
              contentType: MediaType('image', 'jpeg'),
            );
            files.add(multipartFile);
          }
        }

        final formData = FormData.fromMap({
          'files': files,
        });

        final result = await defaultAdsRepository.addDefaultAdsContentApi(formData, defaultAdsUuid);

        result.when(
          success: (data) {
            addDefaultAdsContentImageState.success = data;
          },
          failure: (NetworkExceptions error) {
            // Optional: handle error
          },
        );
      } catch (e) {
        // Optional: handle exception
      } finally {
        addDefaultAdsContentImageState.isLoading = false;
        notifyListeners();
      }
    }
    return addDefaultAdsContentImageState;
  }

  /// Upload Ads Add Video Content
  UIState<CommonResponseModel> addDefaultAdsContentVideoState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> addDefaultAdsContentVideoApi(BuildContext context, {required String defaultAdsUuid}) async {
    if (selectedDocumentFile != null) {
      addDefaultAdsContentVideoState.isLoading = true;
      addDefaultAdsContentVideoState.success = null;
      notifyListeners();

      FormData? formData;
      // MultipartFile contentVideo = MultipartFile.fromBytes(selectedDocumentFile! as List<int>, filename: documentName, contentType: MediaType('image', 'jpeg'));
      MultipartFile contentVideo = MultipartFile.fromBytes(selectedDocumentData!, filename: documentName, contentType: MediaType('image', 'jpeg'));
      formData = FormData.fromMap({'files': contentVideo});

      final result = await defaultAdsRepository.addDefaultAdsContentApi(formData, defaultAdsUuid);
      result.when(
        success: (data) async {
          addDefaultAdsContentVideoState.success = data;
        },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      addDefaultAdsContentVideoState.isLoading = false;
      notifyListeners();
    }
    return addDefaultAdsContentVideoState;
  }

  /// Validate Ads Content
  UIState<CommonResponseModel> validateAdsContentState = UIState<CommonResponseModel>();

  Future<void> validateAdsContentApi(BuildContext context) async {
    if (selectedDocumentFile != null || selectedDocumentData != null) {
      validateAdsContentState.isLoading = true;
      validateAdsContentState.success = null;
      notifyListeners();


      FormData? formData;
      MultipartFile content = MultipartFile.fromBytes(mediaIndex == 0 ? selectedDocumentData! : selectedDocumentData!, filename: documentName);
      formData = FormData.fromMap({'file': content});

      final result = await defaultAdsRepository.validateAdsContentApi(formData, mediaIndex == 0 ? 'IMAGE' : 'VIDEO',);
      result.when(
        success: (data) async {
          validateAdsContentState.success = data;
        },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      validateAdsContentState.isLoading = false;
      notifyListeners();
    }
  }


/*
  /// ---------------------------- Create Client Ads Api Integration ---------------------------------///
   */

  /// Add Client Add API
  UIState<AddClientAdsResponseModel> addClientAdApiState = UIState<AddClientAdsResponseModel>();

  Future<void> addClientAdsApi(BuildContext context, WidgetRef ref) async {
    addClientAdApiState.isLoading = true;
    addClientAdApiState.success = null;
    notifyListeners();

    final addClientAdsRequestModel = AddClientAdsRequestModel(
      odigoClientUuid: (selectedClientUuid?.isNotEmpty ?? false) ? selectedClientUuid : Session.getClientUuid(),
      name: addTagNameController.text,
      adsMediaType: mediaIndex == 0 ? 'IMAGE' : 'VIDEO',
    );

    final result = await clientApiRepository.addClientAdsApi(request: addClientAdsRequestModelToJson(addClientAdsRequestModel));
    result.when(
      success: (data) async {
        addClientAdApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );
    addClientAdApiState.isLoading = false;
    notifyListeners();
  }

  /// Update Client Add Name API
  UIState<CommonResponseModel> updateClientAdsNameApiState = UIState<CommonResponseModel>();

  Future<void> updateClientAdNameApi(BuildContext context, String uuid) async {
    updateClientAdsNameApiState.isLoading = true;
    updateClientAdsNameApiState.success = null;
    notifyListeners();

    final updateClientAdsRequestModel = UpdateClientAdsRequestModel(
      uuid: uuid,
      name: addTagNameController.text

    );

    final result = await clientApiRepository.updateClientAdsNameApi(request: updateClientAdsRequestModelToJson(updateClientAdsRequestModel));
    result.when(
      success: (data) async {
        updateClientAdsNameApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    updateClientAdsNameApiState.isLoading = false;
    notifyListeners();
  }

  /// Upload Ads Add Image Content
  UIState<CommonResponseModel> addClientAdsContentImageState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> addClientAdsContentImageApi(BuildContext context, {required String clientAdsUuid}) async {
    if (listImages.isNotEmpty) {
      addClientAdsContentImageState.isLoading = true;
      addClientAdsContentImageState.success = null;
      notifyListeners();

      try {
        List<MultipartFile> files = [];

        for (var image in listImages) {
          if (image.selectedData != null) {
            final multipartFile = MultipartFile.fromBytes(
              image.selectedData!,
              filename: image.documentName,
              contentType: MediaType('image', 'jpeg'),
            );
            files.add(multipartFile);
          }
        }

        final formData = FormData.fromMap({
          'files': files,
        });

        final result = await clientApiRepository.addClientAdsContentApi(formData, clientAdsUuid);

        result.when(
          success: (data) {
            addClientAdsContentImageState.success = data;
          },
          failure: (NetworkExceptions error) {
            // Optional: handle error
          },
        );
      } catch (e) {
        // Optional: handle exception
      } finally {
        addClientAdsContentImageState.isLoading = false;
        notifyListeners();
      }
    }
    return addClientAdsContentImageState;
  }

  /// Upload Ads Add Video Content
  UIState<CommonResponseModel> addClientAdsContentVideoState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> addClientAdsContentVideoApi(BuildContext context, {required String clientAdsUuid}) async {
    if (selectedDocumentFile != null) {
      addClientAdsContentVideoState.isLoading = true;
      addClientAdsContentVideoState.success = null;
      notifyListeners();

      FormData? formData;
      MultipartFile contentVideo = MultipartFile.fromBytes(selectedDocumentData!, filename: documentName, contentType: MediaType('image', 'jpeg'));
      formData = FormData.fromMap({'files': contentVideo});

      final result = await clientApiRepository.addClientAdsContentApi(formData, clientAdsUuid);
      result.when(
        success: (data) async {
          addClientAdsContentVideoState.success = data;
        },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      addClientAdsContentVideoState.isLoading = false;
      notifyListeners();
    }
    return addClientAdsContentVideoState;
  }

  // /// Validate Ads Content
  // UIState<CommonResponseModel> validateAdsContentState = UIState<CommonResponseModel>();
  //
  // Future<void> validateAdsContentApi(BuildContext context) async {
  //   if (selectedDocumentFile != null || selectedDocumentData != null) {
  //     validateAdsContentState.isLoading = true;
  //     validateAdsContentState.success = null;
  //     notifyListeners();
  //
  //     FormData? formData;
  //     MultipartFile content = MultipartFile.fromBytes(mediaIndex == 0 ? selectedDocumentData! : selectedDocumentFile! as List<int>, filename: documentName);
  //     formData = FormData.fromMap({'file': content});
  //
  //     final result = await clientApiRepository.validateAdsContentApi(formData, mediaIndex == 0 ? 'IMAGE' : 'VIDEO',);
  //     result.when(
  //       success: (data) async {
  //         validateAdsContentState.success = data;
  //       },
  //       failure: (NetworkExceptions error) {
  //         //String errorMsg = NetworkExceptions.getErrorMessage(error);
  //         //       showCommonErrorDialog(context: context, message: errorMsg);
  //       },
  //     );
  //
  //     validateAdsContentState.isLoading = false;
  //     notifyListeners();
  //   }
  // }
}

class DocumentData{
  Uint8List? selectedData;
  File? selectedFile;
  String? documentName;
  String? documentSize;
  FileType? fileType;
  String? fileUrl;

  DocumentData({this.selectedFile,this.selectedData,this.documentName,this.documentSize,this.fileType, this.fileUrl});
}


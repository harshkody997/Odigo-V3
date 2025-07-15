import 'dart:convert';
import 'package:odigov3/framework/provider/network/dio/common_error_model.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/delegate.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';

bool enableLogoutDialog = true;

InterceptorsWrapper networkInterceptor() {
  CancelToken cancelToken = CancelToken();
  return InterceptorsWrapper(
    onRequest: (request, handler) {
      List<String> apiEndPointWhereTokenNotRequired = [];
      for (var apiEndPoint in apiEndPointWhereTokenNotRequired) {
        if (request.uri.path == (apiEndPoint)) {
          request.headers.remove('Authorization');
        }
      }
      request.cancelToken = cancelToken;
      handler.next(request);
    },
    onResponse: (response, handler) {
      print("response.realUri.path>>>>${response.realUri.path}");
      List<String> whiteListAPIs = ['/country/export', '/odigo/package/wallet/transaction/export/list'];
      try {
        if ((!whiteListAPIs.contains(response.realUri.path)) && (response.data is Map || (response.data is String && response.data.toString().isNotEmpty))) {
          CommonErrorModel commonModel = CommonErrorModel.fromJson(jsonDecode(response.toString()));
          if (commonModel.status != ApiEndPoints.apiStatus_200 /*&& commonModel.status != 500*/ ) {
            if (globalNavigatorKey.currentState?.context != null) {
              handler.next(response);
              return;
            }
          } else if (commonModel.status == 500) {
            // globalRef!.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.error(errorType: ErrorType.error403));
          }
        }
        handler.next(response);
      } catch (e, s) {
        AppConstants.constant.showLog('${AppConstants.stacktrace} $s');
        handler.reject(DioException(requestOptions: response.requestOptions, response: response, error: const NetworkExceptions.unexpectedError()), false);
      }
    },
    onError: (error, handler) {
      final response = error.response;

      print("object onErroronError ${error.response}");
      List<String> whiteListAPIs = [];
      try {
        if ((!whiteListAPIs.contains(response?.realUri.path)) &&
            /// If bytes is error response
            error.requestOptions.responseType == ResponseType.bytes?
             (utf8.decode(response?.data).isNotEmpty)
              /// String respose
            :(response?.data is Map || (response?.data is String && response!.data.toString().isNotEmpty))
        ) {
          CommonErrorModel commonModel = CommonErrorModel.fromJson(jsonDecode(error.requestOptions.responseType == ResponseType.bytes ? utf8.decode(response?.data): response.toString()));          if (commonModel.status != ApiEndPoints.apiStatus_200) {
            if (globalNavigatorKey.currentState?.context != null) {
              showErrorDialogue(
                context: globalNavigatorKey.currentContext!,
                dismissble: true,
               // height: MediaQuery.sizeOf(globalNavigatorKey.currentContext!).height * 0.45,
                width: MediaQuery.sizeOf(globalNavigatorKey.currentContext!).width * 0.3,
                buttonText: LocaleKeys.keyOk.localized,
                onTap: ()async
                {
                if(commonModel.status == ApiEndPoints.apiStatus_401 || commonModel.status == ApiEndPoints.apiStatus_406){
                  String appLanguageUUid = Session.getAppLanguage();
                  await Session.sessionBox.clear().then((value) {
                    Session.saveLocalData(keyAppLanguage, appLanguageUUid);
                    showLog('appLanguageUUid : ${Session.getAppLanguage()}');

                    debugPrint('===========================YOU LOGGED OUT FROM THE APP==============================');
                    Navigator.of(globalNavigatorKey.currentState!.context).pop();
                    AppConstants.constant.globalRef?.read(navigationStackController).pushAndRemoveAll( const NavigationStackItem.login());

                  });

                }
                else {
                  Navigator.pop(globalNavigatorKey.currentContext!);
                }

                },
                animation: Assets.anim.animErrorJson.keyName,
                successMessage:
                commonModel.errorMessage == null ? (commonModel.message ?? '') : (commonModel.errorMessage ?? ''),

              );
              handler.reject(error);
              return;
            }
            else{
              var errorData = NetworkExceptions.getDioException(error);
              String errorMsg = NetworkExceptions.getErrorMessage(errorData);
              if (globalNavigatorKey.currentState?.context != null) {
                showErrorDialogue(
                  context: globalNavigatorKey.currentContext!,
                  dismissble: true,
                  //  height: MediaQuery.sizeOf(globalNavigatorKey.currentContext!).height * 0.45,
                  width: MediaQuery.sizeOf(globalNavigatorKey.currentContext!).width * 0.3,
                  buttonText: LocaleKeys.keyOk.localized,
                  onTap: ()async
                  {
                    if(commonModel.status == ApiEndPoints.apiStatus_401 ){
                      String appLanguageUUid = Session.getAppLanguage();
                      await Session.sessionBox.clear().then((value) {
                        Session.saveLocalData(keyAppLanguage, appLanguageUUid);
                        showLog('appLanguageUUid : ${Session.getAppLanguage()}');

                        debugPrint('===========================YOU LOGGED OUT FROM THE APP==============================');
                        Navigator.of(globalNavigatorKey.currentState!.context).pop();
                        AppConstants.constant.globalRef?.read(navigationStackController).pushAndRemoveAll( const NavigationStackItem.login());

                      });


                    }
                    else {
                      Navigator.pop(globalNavigatorKey.currentContext!);
                    }

                  },
                  animation: Assets.anim.animErrorJson.keyName,
                  successMessage:errorMsg
                );

                return;
              }

            }
            handler.reject(error);
          }
        }
        // handler.next(response as DioException);
        handler.next(error);

      } catch (e, s) {

        handler.reject(
          DioException(requestOptions: response!.requestOptions, response: response, error: const NetworkExceptions.unexpectedError()),
        );
      }
      handler.next(error);
    },
  );
}

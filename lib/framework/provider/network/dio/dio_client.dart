import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  /// Set headers and header Authorization
  Map<String, dynamic> getHeader({bool isTokenRequiredInHeader = true}) {
    Map<String, dynamic> headers = {
      AppConstants.accept: AppConstants.headerAccept,
      AppConstants.contentType: AppConstants.headerContentType,
      AppConstants.acceptLanguage: Session.getAppLanguage(),
    };
    if (isTokenRequiredInHeader) {
      ///Authorization Header
      String token = Session.userAccessToken;
      if (token.isNotEmpty) {
        headers.addAll({'X-Auth-Token': Session.userAccessToken});
      }
    }
    return headers;
  }

  /*
  * ----GET Request
  * */
  Future<dynamic> getRequest(String endPoint, {bool isBytes = false}) async {
    try {
      ///Basic Headers
      // Map<String, dynamic> headers = {
      //   'Accept': 'application/json',
      //   'contentType':'application/json',
      //   'Accept-Language': Session.getAppLanguage(),
      // };

      ///Authorization Header
      // String token = Session.getUserAccessToken();
      // if(token.isNotEmpty){
      //   headers.addAll({'Authorization': 'Bearer ${Session.getUserAccessToken()}'});
      // }

      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.get(endPoint, options: Options(responseType: ResponseType.bytes));
      } else {
        return await _dio.get(endPoint);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request
  * */
  Future<dynamic> postRequest(String endPoint, String? requestBody, {bool isTokenRequiredInHeader = true, bool isBytes = false}) async {
    try {
      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.post(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(endPoint, data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request FormData
  * */
  Future<dynamic> postRequestFormData(String endPoint, FormData requestBody, {bool isBytes = false, ProgressCallback? onSendProgress}) async {
    try {
      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.post(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(endPoint, data: requestBody, onSendProgress: onSendProgress);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PUT Request
  * */
  Future<dynamic> putRequest(String endPoint, String? requestBody) async {
    try {
      _dio.options.headers = getHeader();
      return await _dio.put(endPoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PUT Request FormData
  * */
  Future<dynamic> putRequestFormData(String endPoint, FormData requestBody) async {
    try {
      _dio.options.headers = getHeader();
      return await _dio.put(endPoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----DELETE Request
  * */
  Future<dynamic> deleteRequest(String endPoint, String? requestBody) async {
    try {
      _dio.options.headers = getHeader();
      return await _dio.delete(endPoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }
}

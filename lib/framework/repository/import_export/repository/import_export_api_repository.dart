
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart';

@LazySingleton(as: ImportExportRepository, env: [Env.debug, Env.production])
class ImportExportApiRepository implements ImportExportRepository {
  final DioClient apiClient;

  ImportExportApiRepository(this.apiClient);
  /// Import ticket reason
  @override
  Future importApi(FormData formData,{required String endPoint}) async {
    try {
      Response bytes = await apiClient.postRequestFormData(endPoint, formData, isBytes: true);
      if (bytes.data == null) {
        return const ApiResult.failure(error: NetworkExceptions.defaultError('Something went wrong'));
      } else {
        return ApiResult.success(data: bytes);
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Export ticket reason
  @override
  Future exportApi({required String request,required String endPoint}) async {
    try {
      Response bytes = await apiClient.postRequest(endPoint,request,isBytes: true);
      if (bytes.statusCode!=200) {
        return  const ApiResult.failure(error: NetworkExceptions.defaultError('Something went wrong'));
      } else {
        return ApiResult.success(data: bytes);
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Export reason
  @override
  Future exportSample({required String endPoint}) async {
    try {
      Response bytes = await apiClient.getRequest(endPoint,isBytes: true);
      if (bytes.data == null) {
        return  const ApiResult.failure(error: NetworkExceptions.defaultError('Something went wrong'));
      } else {
        return ApiResult.success(data: bytes);
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}

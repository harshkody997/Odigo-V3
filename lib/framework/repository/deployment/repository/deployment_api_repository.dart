import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/deployment/contract/deployment_repository.dart';
import 'package:odigov3/framework/repository/deployment/model/deployment_list_response_model.dart';

@LazySingleton(as: DeploymentRepository, env: Env.environments)
class DeploymentApiRepository implements DeploymentRepository{
  final DioClient apiClient;
  DeploymentApiRepository(this.apiClient);


  @override
  Future deploymentListApi(int page,String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.deploymentList(page,),request);
      DeploymentListResponseModel responseModel = deploymentListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addNewDeploymentApi(FormData formData) async{
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.deployment,formData);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}

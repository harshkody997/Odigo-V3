import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/category/contract/category_repository.dart';
import 'package:odigov3/framework/repository/master/category/model/add_edit_category_response_model.dart';
import 'package:odigov3/framework/repository/master/category/model/category_details_response_model.dart';
import 'package:odigov3/framework/repository/master/category/model/category_list_response_model.dart';

@LazySingleton(as: CategoryRepository, env: [Env.production, Env.debug])
class CategoryApiRepository implements CategoryRepository {
  final DioClient apiClient;
  CategoryApiRepository(this.apiClient);

  @override
  Future getCategoryListAPI(int pageNo, int pageSize, String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getCategoryList(pageNo, pageSize),request);
      CategoryListResponseModel responseModel = categoryListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addCategoryApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addEditCategory,request);
      AddEditCategoryResponseModel responseModel = addEditCategoryResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future editCategoryApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.addEditCategory,request);
      AddEditCategoryResponseModel responseModel = addEditCategoryResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future categoryDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.categoryDetails(uuid));
      CategoryDetailsResponseModel responseModel = categoryDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeCategoryStatusApi(String uuid, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeCategoryStatus(uuid, status),'{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future uploadCategoryImageApi(String uuid, FormData request) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.uploadCategoryImage(uuid),request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}

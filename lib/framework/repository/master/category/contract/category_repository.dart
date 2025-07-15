import 'package:dio/dio.dart';

abstract class CategoryRepository {

  /// category list api
  Future getCategoryListAPI(int pageNo,int pageSize,String request);

  Future addCategoryApi(String request);

  Future editCategoryApi(String request);

  Future changeCategoryStatusApi(String uuid,bool status);

  Future categoryDetailsApi(String uuid);

  Future uploadCategoryImageApi(String uuid,FormData request);
}

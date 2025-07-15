import 'package:dio/dio.dart';

abstract class ImportExportRepository {
  ///Import ticket reason
  Future importApi(FormData request,{required String endPoint});

  ///Export ticket reason
  Future exportApi({required String request,required String endPoint});

  ///Export reason
  Future exportSample({required String endPoint});
}

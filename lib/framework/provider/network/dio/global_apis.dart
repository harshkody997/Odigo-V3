class GlobalApis {
  GlobalApis._privateConstructor();

  static final GlobalApis instance = GlobalApis._privateConstructor();

  // ///Get Country List Api
  // ///Usage -> GlobalApis.instance.getCountryListApi(context, (model, error) {});
  // Future getCountryListApi(
  //     BuildContext context,
  //     Function(CountryListResponseModel? model, NetworkExceptions? error)
  //         callBackBlock) async {
  //   late ApiResult apiResult;
  //
  //   Map<String, dynamic> headers = {
  //     'Accept': 'application/json',
  //     'contentType': 'application/json',
  //     'Accept-Language': Session.getAppLanguage(),
  //   };
  //
  //   try {
  //     Response? response = await DioClient(Dio(
  //       BaseOptions(
  //         baseUrl: 'https://begsha.kodyinfotech.com/api/vendor/',
  //         headers: headers,
  //         sendTimeout: const Duration(milliseconds: 500000),
  //         connectTimeout: const Duration(milliseconds: 500000),
  //         receiveTimeout: const Duration(milliseconds: 500000),
  //       ),
  //     )).getRequest(ApiEndPoints.countryList);
  //     CountryListResponseModel responseModel =
  //         countryListResponseModelFromJson(response.toString());
  //     apiResult = ApiResult.success(data: responseModel);
  //   } catch (err) {
  //     apiResult =
  //         ApiResult.failure(error: NetworkExceptions.getDioException(err));
  //   }
  //
  //   apiResult.when(success: (data) async {
  //     callBackBlock(data as CountryListResponseModel, null);
  //   }, failure: (NetworkExceptions error) async{
  //     String errorMsg = NetworkExceptions.getErrorMessage(error);
  //     await showMessageDialog(context, errorMsg, null);
  //     callBackBlock(null, error);
  //   });
  // }
}

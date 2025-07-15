import 'package:dio/dio.dart';

abstract class StoreRepository {

    ///store list Api
    Future storeListApi({required String request,required int pageNumber, int dataSize});

    ///change store status Api
    Future changeStoreStatusApi({required String storeUuid, required bool isActive});

    ///store detail Api
    Future storeDetailApi({required String storeUuid});

    ///store language detail Api
    Future storeLanguageDetailApi({required String storeUuid});

    ///Add Edit store
    Future addEditStoreApi(String request, bool forAdd);

    ///upload store image
    Future uploadStoreImage(FormData formData, String storeUuid);


}


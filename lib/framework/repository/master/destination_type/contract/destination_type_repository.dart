
abstract class DestinationTypeRepository {

  Future getDestinationTypeListApi(int pageNo, int pageSize, String? destinationUuid, String request);

  Future addDestinationTypeApi(String request);

  Future editDestinationTypeApi(String request);

  Future changeDestinationTypeStatusApi(String uuid,bool status);

  Future destinationTypeDetailsApi(String uuid);
}

abstract class StateRepository {

  Future getStateListApi(int pageNo,int pageSize,String request);

  Future addStateApi(String request);

  Future editStateApi(String request);

  Future changeStateStatusApi(String uuid,bool status);

  Future stateDetailsApi(String uuid);

}
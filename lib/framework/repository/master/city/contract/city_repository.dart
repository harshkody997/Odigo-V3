abstract class CityRepository {

  /// city list
  Future getCityListAPI(int pageNo,int pageSize,String request);

  Future addCityApi(String request);

  Future editCityApi(String request);

  Future changeCityStatusApi(String uuid,bool status);

  Future cityDetailsApi(String uuid);
}

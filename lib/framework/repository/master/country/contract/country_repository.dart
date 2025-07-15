abstract class CountryRepository {

  /// country list
  Future getCountryListAPI(int pageNo,int pageSize,String request);

  Future getCountryTimeZoneAPI();
}

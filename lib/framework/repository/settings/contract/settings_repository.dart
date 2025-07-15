abstract class SettingsRepository{

  ///Get Settings List
  Future getSettingsList({required int pageNo, required int dataSize});

  ///Update Settings
  Future updateSetting(String request);

}
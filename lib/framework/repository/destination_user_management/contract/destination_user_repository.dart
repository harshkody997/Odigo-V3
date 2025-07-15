abstract class DestinationUserRepository{

  /// Destination user list api
  Future destinationUserListApi(String searchText, int pageNo,{bool? isActive});

  /// Destination user details api
  Future getDestinationUserDetails(String userUuid);

  /// Change password api
  Future changeDestinationUserPassword(String request);

  /// Update user status api
  Future updateDestinationUserStatusApi(String userId,bool status);

  /// Add/Update Destination user api
  Future addUpdateDestinationUserApi(String request, {bool? isUpdate});

}
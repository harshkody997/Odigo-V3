abstract class UserManagementRepository {
  /// Add User Api
  Future addUserApi(String request);

  /// Update User Api
  Future updateUserApi(String request);

  /// Active DeActive User Api
  Future activeDeActiveUserApi(String userId, bool isActive);

  /// Get User Details Api
  Future getUserDetailsApi(String userId);

  /// Get Users List Api
  Future getUsersListApi(int pageNumber, String searchKeyword);

  /// Get Assign Type Api
  Future getAssignTypeApi(String request, int pageNumber, {bool? isActive});
}

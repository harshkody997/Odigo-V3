
abstract class RolePermissionRepository {

    ///role permission Api
    Future roleListApi(String request, int pageNo,int pageSize,bool? activeRecords);

    /// role permission details
    Future rolePermissionDetailsApi(String uuid);

    /// add role permission
    Future addUpdateRolePermissionApi(String request);


    ///change role status
    Future changeRoleStatus(String uuid, bool isActive);

    ///module list Api
    Future moduleListApi(String request, int pageNo,int pageSize);

}


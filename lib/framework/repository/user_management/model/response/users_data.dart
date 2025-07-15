class UserData {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  int? roleId;
  String? roleUuid;
  String? roleName;
  bool? active;
  String? status;
  dynamic userLoginUuid;

  UserData({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.roleId,
    this.roleUuid,
    this.roleName,
    this.active,
    this.status,
    this.userLoginUuid,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uuid: json["uuid"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    roleId: json["roleId"],
    roleUuid: json["roleUuid"],
    roleName: json["roleName"],
    active: json["active"],
    status: json["status"],
    userLoginUuid: json["userLoginUuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "roleId": roleId,
    "roleUuid": roleUuid,
    "roleName": roleName,
    "active": active,
    "status": status,
    "userLoginUuid": userLoginUuid,
  };
}
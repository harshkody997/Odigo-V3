// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  String? message;
  Data? data;
  int? status;

  LoginResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class Data {
  dynamic scope;
  String? userUuid;
  int? userId;
  dynamic roleId;
  String? uuid;
  String? name;
  String? message;
  int? status;
  String? entityUuid;
  int? entityId;
  String? entityType;
  String? email;
  String? contactNumber;
  dynamic profileImage;
  String? roleUuid;
  String? roleName;
  bool? canChangePassword;
  bool? emailVerified;
  bool? contactVerified;
  dynamic robotUuid;
  dynamic destinationUuid;
  dynamic entityStatus;
  dynamic countryUuid;
  dynamic currencyName;
  dynamic passcode;
  dynamic aesSecretKey;
  dynamic aesSalt;
  bool? apiOfflineEncryption;
  bool? videoOfflineEncryption;
  bool? apiAdminEncryption;
  bool? videoAdminEncryption;
  String? languageUuid;
  String? languageCode;
  String? languageName;
  dynamic forceUpdatePassword;
  CountryLanguageResponseDto? countryLanguageResponseDto;
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  Data({
    this.scope,
    this.userUuid,
    this.userId,
    this.roleId,
    this.uuid,
    this.name,
    this.message,
    this.status,
    this.entityUuid,
    this.entityId,
    this.entityType,
    this.email,
    this.contactNumber,
    this.profileImage,
    this.roleUuid,
    this.roleName,
    this.canChangePassword,
    this.emailVerified,
    this.contactVerified,
    this.robotUuid,
    this.destinationUuid,
    this.entityStatus,
    this.countryUuid,
    this.currencyName,
    this.passcode,
    this.aesSecretKey,
    this.aesSalt,
    this.apiOfflineEncryption,
    this.videoOfflineEncryption,
    this.apiAdminEncryption,
    this.videoAdminEncryption,
    this.languageUuid,
    this.languageCode,
    this.languageName,
    this.forceUpdatePassword,
    this.countryLanguageResponseDto,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    scope: json['scope'],
    userUuid: json['userUuid'],
    userId: json['userId'],
    roleId: json['roleId'],
    uuid: json['uuid'],
    name: json['name'],
    message: json['message'],
    status: json['status'],
    entityUuid: json['entityUuid'],
    entityId: json['entityId'],
    entityType: json['entityType'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    profileImage: json['profileImage'],
    roleUuid: json['roleUuid'],
    roleName: json['roleName'],
    canChangePassword: json['canChangePassword'],
    emailVerified: json['emailVerified'],
    contactVerified: json['contactVerified'],
    robotUuid: json['robotUuid'],
    destinationUuid: json['destinationUuid'],
    entityStatus: json['entityStatus'],
    countryUuid: json['countryUuid'],
    currencyName: json['currencyName'],
    passcode: json['passcode'],
    aesSecretKey: json['aesSecretKey'],
    aesSalt: json['aesSalt'],
    apiOfflineEncryption: json['apiOfflineEncryption'],
    videoOfflineEncryption: json['videoOfflineEncryption'],
    apiAdminEncryption: json['apiAdminEncryption'],
    videoAdminEncryption: json['videoAdminEncryption'],
    languageUuid: json['languageUuid'],
    languageCode: json['languageCode'],
    languageName: json['languageName'],
    forceUpdatePassword: json['forceUpdatePassword'],
    countryLanguageResponseDto: json['countryLanguageResponseDTO'] == null ? null : CountryLanguageResponseDto.fromJson(json['countryLanguageResponseDTO']),
    accessToken: json['access_token'],
    tokenType: json['token_type'],
    expiresIn: json['expires_in'],
  );

  Map<String, dynamic> toJson() => {
    'scope': scope,
    'userUuid': userUuid,
    'userId': userId,
    'roleId': roleId,
    'uuid': uuid,
    'name': name,
    'message': message,
    'status': status,
    'entityUuid': entityUuid,
    'entityId': entityId,
    'entityType': entityType,
    'email': email,
    'contactNumber': contactNumber,
    'profileImage': profileImage,
    'roleUuid': roleUuid,
    'roleName': roleName,
    'canChangePassword': canChangePassword,
    'emailVerified': emailVerified,
    'contactVerified': contactVerified,
    'robotUuid': robotUuid,
    'destinationUuid': destinationUuid,
    'entityStatus': entityStatus,
    'countryUuid': countryUuid,
    'currencyName': currencyName,
    'passcode': passcode,
    'aesSecretKey': aesSecretKey,
    'aesSalt': aesSalt,
    'apiOfflineEncryption': apiOfflineEncryption,
    'videoOfflineEncryption': videoOfflineEncryption,
    'apiAdminEncryption': apiAdminEncryption,
    'videoAdminEncryption': videoAdminEncryption,
    'languageUuid': languageUuid,
    'languageCode': languageCode,
    'languageName': languageName,
    'forceUpdatePassword': forceUpdatePassword,
    'countryLanguageResponseDTO': countryLanguageResponseDto?.toJson(),
    'access_token': accessToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
  };
}

class CountryLanguageResponseDto {
  String? uuid;
  String? name;
  String? currency;
  String? code;
  bool? active;

  CountryLanguageResponseDto({
    this.uuid,
    this.name,
    this.currency,
    this.code,
    this.active,
  });

  factory CountryLanguageResponseDto.fromJson(Map<String, dynamic> json) => CountryLanguageResponseDto(
    uuid: json['uuid'],
    name: json['name'],
    currency: json['currency'],
    code: json['code'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'currency': currency,
    'code': code,
    'active': active,
  };
}

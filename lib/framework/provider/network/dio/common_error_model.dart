import 'dart:convert';
import 'package:odigov3/ui/utils/app_constants.dart';

CommonErrorModel commonErrorModelFromJson(String str) {
  try {
    final data = json.decode(str == AppConstants.nullString || str.isEmpty ? AppConstants.emptyString : str);
    return CommonErrorModel.fromJson(data);
  } catch (e) {
    return CommonErrorModel();
  }
}

class CommonErrorModel<T> {
  CommonErrorModel({
    this.message,
    this.data,
    this.status,
    this.errorMessage
  });

  String? message;
  dynamic data;
  int? status;
  String? errorMessage;

  factory CommonErrorModel.fromJson(Map<String, dynamic> json) =>
      CommonErrorModel(
        message: json['message']??json['error'] ?? AppConstants.error,
        data: json['data'],
        status: json['status'] ?? 0,
      );

}

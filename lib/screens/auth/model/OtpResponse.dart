import 'package:sahajghara/screens/utils/JsonHelper.dart';

class OtpResponse {
  Result? result;
  bool? hasError;
  String? message;

  OtpResponse({this.result, this.hasError, this.message});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] is Map ? new Result.fromJson(json['result']) : null;
    hasError = JsonHelper.toNullableBool(json['HasError']);
    message = JsonHelper.toStringValue(json['Message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['HasError'] = this.hasError;
    data['Message'] = this.message;
    return data;
  }
}

class Result {
  User? user;
  int? otp;
  bool? register;
  String? authkey;

  Result({this.user, this.otp, this.register, this.authkey});

  // Result.fromJson(Map<String, dynamic> json) {
  //   user = json['user'] is Map ? new User.fromJson(json['user']) : null;
  //   otp = JsonHelper.toInt(json['otp']);
  //   register = JsonHelper.toNullableBool(json['register']);
  //   authkey = JsonHelper.toStringValue(json['authkey']);
  // }
  Result.fromJson(Map<String, dynamic> json) {
    if (json['user'] is Map<String, dynamic>) {
      user = User.fromJson(json['user']);
    } else {
      user = null; // handles [], null, or invalid type
    }
    otp = JsonHelper.toInt(json['otp']);
    register = JsonHelper.toNullableBool(json['register']);
    authkey = JsonHelper.toStringValue(json['authkey']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['otp'] = this.otp;
    data['register'] = this.register;
    data['authkey'] = this.authkey;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? phone;
  String? email;
  String? emailVarifyOtp;
  String? emailVerifiedAt;
  String? phoneVarifyOtp;
  String? phoneVerifiedAt;
  int? status;
  String? type;

  String? password;

  User(
      {this.sId,
        this.name,
        this.phone,
        this.email,
        this.emailVarifyOtp,
        this.emailVerifiedAt,
        this.phoneVarifyOtp,
        this.phoneVerifiedAt,
        this.status,
        this.type,
        this.password});

  User.fromJson(Map<String, dynamic> json) {
    sId = JsonHelper.toStringValue(json['_id']);
    name = JsonHelper.toStringValue(json['name']);
    phone = JsonHelper.toStringValue(json['phone']);
    email = JsonHelper.toStringValue(json['email']);
    emailVarifyOtp = JsonHelper.toStringValue(json['email_varify_otp']);
    emailVerifiedAt = JsonHelper.toStringValue(json['email_verified_at']);
    phoneVarifyOtp = JsonHelper.toStringValue(json['phone_varify_otp']);
    phoneVerifiedAt = JsonHelper.toStringValue(json['phone_verified_at']);
    status = JsonHelper.toInt(json['status']);
    type = JsonHelper.toStringValue(json['type']);

    password = JsonHelper.toStringValue(json['password']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['email_varify_otp'] = this.emailVarifyOtp;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_varify_otp'] = this.phoneVarifyOtp;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['status'] = this.status;
    data['type'] = this.type;

    data['password'] = this.password;
    return data;
  }
}

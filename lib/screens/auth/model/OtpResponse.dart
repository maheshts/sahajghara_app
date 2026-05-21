class OtpResponse {
  Result? result;
  bool? hasError;
  String? message;

  OtpResponse({this.result, this.hasError, this.message});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    hasError = json['HasError'];
    message = json['Message'];
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
  //   user = json['user'] != null ? new User.fromJson(json['user']) : null;
  //   otp = json['otp'];
  //   register = json['register'];
  //   authkey = json['authkey'];
  // }
  Result.fromJson(Map<String, dynamic> json) {
    if (json['user'] is Map<String, dynamic>) {
      user = User.fromJson(json['user']);
    } else {
      user = null; // handles [], null, or invalid type
    }
    otp = json['otp'];
    register = json['register'];
    authkey = json['authkey'];
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
  String? createdAt;
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
        this.createdAt,
        this.password});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    emailVarifyOtp = json['email_varify_otp'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVarifyOtp = json['phone_varify_otp'];
    phoneVerifiedAt = json['phone_verified_at'];
    status = json['status'];
    type = json['type'];
    createdAt = json['created_at'];
    password = json['password'];
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
    data['created_at'] = this.createdAt;
    data['password'] = this.password;
    return data;
  }
}

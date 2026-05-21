class RegisterResponse {
  Result? result;
  bool? hasError;
  String? message;

  RegisterResponse({this.result, this.hasError, this.message});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
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
  bool? emailVarify;
  bool? phoneVarify;

  Result({this.user, this.emailVarify, this.phoneVarify});

  Result.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    emailVarify = json['email_varify'];
    phoneVarify = json['phone_varify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['email_varify'] = this.emailVarify;
    data['phone_varify'] = this.phoneVarify;
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

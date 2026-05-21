class EnquiryResponse {
  Result? result;
  bool? hasError;
  String? message;

  EnquiryResponse({this.result, this.hasError, this.message});

  EnquiryResponse.fromJson(Map<String, dynamic> json) {
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
  int? code;

  Result({this.code});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

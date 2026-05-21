class ContractorEnquiryListResponse {
  bool? hasError;
  String? message;
  Result? result;

  ContractorEnquiryListResponse({this.hasError, this.message, this.result});

  ContractorEnquiryListResponse.fromJson(Map<String, dynamic> json) {
    hasError = json['HasError'];
    message = json['Message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasError'] = this.hasError;
    data['Message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? currentPage;
  int? total;
  int? perPage;
  List<CList>? list;

  Result({this.currentPage, this.total, this.perPage, this.list});

  Result.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    total = json['total'];
    perPage = json['per_page'];
    if (json['list'] != null) {
      list = <CList>[];
      json['list'].forEach((v) {
        list!.add(new CList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CList {
  String? sId;
  String? type;
  String? name;
  String? phone;
  String? email;
  String? projectType;
  String? projectSize;
  String? location;
  String? comments;
  int? status;
  int? code;
  String? createdAt;
  String? vendorName;
  String? contractorName;
  String? contractorCode;
  String? customerName;

  CList(
      {this.sId,
        this.type,
        this.name,
        this.phone,
        this.email,
        this.projectType,
        this.projectSize,
        this.location,
        this.comments,
        this.status,
        this.code,
        this.createdAt,
        this.vendorName,
        this.contractorName,
        this.contractorCode,
        this.customerName});

  CList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    projectType = json['project_type'];
    projectSize = json['project_size'];
    location = json['location'];
    comments = json['comments'];
    status = json['status'];
    code = json['code'];
    createdAt = json['createdAt'];
    vendorName = json['vendor_name'];
    contractorName = json['contractor_name'];
    contractorCode = json['contractor_code'];
    customerName = json['customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['project_type'] = this.projectType;
    data['project_size'] = this.projectSize;
    data['location'] = this.location;
    data['comments'] = this.comments;
    data['status'] = this.status;
    data['code'] = this.code;
    data['createdAt'] = this.createdAt;
    data['vendor_name'] = this.vendorName;
    data['customer_name'] = this.customerName;
    data['contractor_name'] = this.contractorName;
    data['contractor_code'] = this.contractorCode;
    return data;
  }
}

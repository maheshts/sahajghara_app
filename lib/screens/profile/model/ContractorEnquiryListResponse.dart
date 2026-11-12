import 'package:sahajghara/screens/utils/JsonHelper.dart';

class ContractorEnquiryListResponse {
  bool? hasError;
  String? message;
  Result? result;

  ContractorEnquiryListResponse({this.hasError, this.message, this.result});

  ContractorEnquiryListResponse.fromJson(Map<String, dynamic> json) {
    hasError = JsonHelper.toNullableBool(json['HasError']);
    message = JsonHelper.toStringValue(json['Message']);
    result =
    json['result'] is Map ? new Result.fromJson(json['result']) : null;
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
    currentPage = JsonHelper.toInt(json['current_page']);
    total = JsonHelper.toInt(json['total']);
    perPage = JsonHelper.toInt(json['per_page']);
    if (json['list'] != null) {
      list = <CList>[];
      JsonHelper.objectList(json['list']).forEach((v) {
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
    sId = JsonHelper.toStringValue(json['_id']);
    type = JsonHelper.toStringValue(json['type']);
    name = JsonHelper.toStringValue(json['name']);
    phone =  JsonHelper.toStringValue(json['phone']);
    email = JsonHelper.toStringValue(json['email']);
    projectType = JsonHelper.toStringValue(json['project_type']);
    projectSize = JsonHelper.toStringValue(json['project_size']);
    location = JsonHelper.toStringValue(json['location']);
    comments = JsonHelper.toStringValue(json['comments']);
    status = JsonHelper.toInt(json['status']);
    code = JsonHelper.toInt(json['code']);
    createdAt = JsonHelper.toStringValue(json['createdAt']);
    vendorName = JsonHelper.toStringValue(json['vendor_name']);
    contractorName = JsonHelper.toStringValue(json['contractor_name']);
    contractorCode = JsonHelper.toStringValue(json['contractor_code']);
    customerName = JsonHelper.toStringValue(json['customer_name']);
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

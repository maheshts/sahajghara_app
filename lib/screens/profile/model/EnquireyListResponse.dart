import 'package:sahajghara/screens/utils/JsonHelper.dart';

class EnquireyListResponse {
  bool? hasError;
  String? message;
  Result? result;

  EnquireyListResponse({this.hasError, this.message, this.result});

  EnquireyListResponse.fromJson(Map<String, dynamic> json) {
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
  List<EnquiryData>? list;

  Result({this.currentPage, this.total, this.perPage, this.list});

  Result.fromJson(Map<String, dynamic> json) {
    currentPage = JsonHelper.toInt(json['current_page']);
    total = JsonHelper.toInt(json['total']);
    perPage = JsonHelper.toInt(json['per_page']);
    if (json['list'] != null) {
      list = <EnquiryData>[];
      JsonHelper.objectList(json['list']).forEach((v) {
        list!.add(new EnquiryData.fromJson(v));
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

class EnquiryData {
  String? sId;
  String? name;
  String? phone;
  String? email;
  int? orderQuantity;
  String? location;
  String? requirmentUrgency;
  String? comments;
  int? status;
  int? code;
  String? createdAt;
  String? categoryName;
  String? brandName;
  String? vendorName;
  String? customerName;
  String? statusMessage;

  EnquiryData(
      {this.sId,
        this.name,
        this.phone,
        this.email,
        this.orderQuantity,
        this.location,
        this.requirmentUrgency,
        this.comments,
        this.status,
        this.code,
        this.createdAt,
        this.categoryName,
        this.brandName,
        this.vendorName,
        this.customerName,this.statusMessage});

  EnquiryData.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    sId = JsonHelper.toStringValue(json['_id']);
    name = JsonHelper.toStringValue(json['name']);
    phone = JsonHelper.toStringValue(json['phone']);
    email = JsonHelper.toStringValue(json['email']);
    orderQuantity = _parseInt(json['order_quantity']);
    location = JsonHelper.toStringValue(json['location']);
    requirmentUrgency = JsonHelper.toStringValue(json['requirment_urgency']);
    comments = JsonHelper.toStringValue(json['comments']);
    status = JsonHelper.toInt(json['status']);
    code = JsonHelper.toInt(json['code']);
    createdAt = JsonHelper.toStringValue(json['createdAt']);
    categoryName = JsonHelper.toStringValue(json['category_name']);
    brandName = JsonHelper.toStringValue(json['brand_name']);
    vendorName = JsonHelper.toStringValue(json['vendor_name']);
    customerName = JsonHelper.toStringValue(json['customer_name']);
    statusMessage = JsonHelper.toStringValue(json['status_message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['order_quantity'] = this.orderQuantity;
    data['location'] = this.location;
    data['requirment_urgency'] = this.requirmentUrgency;
    data['comments'] = this.comments;
    data['status'] = this.status;
    data['code'] = this.code;
    data['createdAt'] = this.createdAt;
    data['category_name'] = this.categoryName;
    data['brand_name'] = this.brandName;
    data['vendor_name'] = this.vendorName;
    data['customer_name'] = this.customerName;
    data['status_message'] = this.statusMessage;
    return data;
  }
}

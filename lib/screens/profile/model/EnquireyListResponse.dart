class EnquireyListResponse {
  bool? hasError;
  String? message;
  Result? result;

  EnquireyListResponse({this.hasError, this.message, this.result});

  EnquireyListResponse.fromJson(Map<String, dynamic> json) {
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
  List<EnquiryData>? list;

  Result({this.currentPage, this.total, this.perPage, this.list});

  Result.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    total = json['total'];
    perPage = json['per_page'];
    if (json['list'] != null) {
      list = <EnquiryData>[];
      json['list'].forEach((v) {
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
        this.customerName});

  EnquiryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    orderQuantity = json['order_quantity'];
    location = json['location'];
    requirmentUrgency = json['requirment_urgency'];
    comments = json['comments'];
    status = json['status'];
    code = json['code'];
    createdAt = json['createdAt'];
    categoryName = json['category_name'];
    brandName = json['brand_name'];
    vendorName = json['vendor_name'];
    customerName = json['customer_name'];
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
    return data;
  }
}

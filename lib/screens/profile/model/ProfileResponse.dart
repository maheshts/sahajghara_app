import 'package:sahajghara/screens/utils/JsonHelper.dart';

import 'dart:ffi';

class ProfileResponse {
  Result? result;
  bool? hasError;
  String? message;

  ProfileResponse({this.result, this.hasError, this.message});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? name;
  String? phone;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  String? password;
  String? addressDetails;
  String? remark;
  String? type;
  String? alternateNumber;
  String? email;
  int? enableVendor;
  int? enableContractor;
  String? requestContractor;
  String? contractorCode;
  String? lat;
  String? long;
  String? vendorCode;
  int? requestVendor;
  String? experience;
  String? grade;
  String? maxProjectBudget;
  String? minProjectBudget;
  String? numberofproject;
  String? cloudinaryId;
  String? profileUrl;
  List<ProductAsignList>? productAsignList;

  Result(
      {this.sId,
        this.name,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.password,
        this.addressDetails,
        this.remark,
        this.type,
        this.alternateNumber,
        this.email,
        this.enableVendor,
        this.enableContractor,
        this.requestContractor,
        this.contractorCode,
        this.lat,
        this.long,
        this.vendorCode,
        this.requestVendor,
        this.experience,
        this.grade,
        this.maxProjectBudget,
        this.minProjectBudget,
        this.numberofproject,
        this.cloudinaryId,
        this.profileUrl,
        this.productAsignList});

  Result.fromJson(Map<String, dynamic> json) {
    sId = JsonHelper.toStringValue(json['_id']);
    name = JsonHelper.toStringValue(json['name']);
    phone = JsonHelper.toStringValue(json['phone']);
    createdAt = json['createdAt'] is Map
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] is Map
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    password = JsonHelper.toStringValue(json['password']);
    addressDetails = JsonHelper.toStringValue(json['address_details']);
    remark = JsonHelper.toStringValue(json['remark']);
    type = JsonHelper.toStringValue(json['type']);
    alternateNumber = JsonHelper.toStringValue(json['alternate_number']);
    email = JsonHelper.toStringValue(json['email']);
    enableVendor = JsonHelper.toInt(json['enable_vendor']);
    enableContractor = JsonHelper.toInt(json['enable_contractor']);
    requestContractor = JsonHelper.toStringValue(json['request_contractor']);
    contractorCode = JsonHelper.toStringValue(json['contractor_code']);
    lat = JsonHelper.toStringValue(json['lat']);
    long = JsonHelper.toStringValue(json['long']);
    vendorCode = JsonHelper.toStringValue(json['vendor_code']);
    requestVendor = JsonHelper.toInt(json['request_vendor']);
    experience = JsonHelper.toStringValue(json['experience']);
    grade = JsonHelper.toStringValue(json['grade']);
    maxProjectBudget = JsonHelper.toStringValue(json['max_project_budget']);
    minProjectBudget = JsonHelper.toStringValue(json['min_project_budget']);
    numberofproject = JsonHelper.toStringValue(json['numberofproject']);
    cloudinaryId = JsonHelper.toStringValue(json['cloudinary_id']);
    profileUrl = JsonHelper.toStringValue(json['profile_url']);
    if (json['ProductAsignList'] != null) {
      productAsignList = <ProductAsignList>[];
      JsonHelper.objectList(json['ProductAsignList']).forEach((v) {
        productAsignList!.add(new ProductAsignList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    if (this.updatedAt != null) {
      data['updatedAt'] = this.updatedAt!.toJson();
    }
    data['password'] = this.password;
    data['address_details'] = this.addressDetails;
    data['remark'] = this.remark;
    data['type'] = this.type;
    data['alternate_number'] = this.alternateNumber;
    data['email'] = this.email;
    data['enable_vendor'] = this.enableVendor;
    data['enable_contractor'] = this.enableContractor;
    data['request_contractor'] = this.requestContractor;
    data['contractor_code'] = this.contractorCode;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['vendor_code'] = this.vendorCode;
    data['request_vendor'] = this.requestVendor;
    data['experience'] = this.experience;
    data['grade'] = this.grade;
    data['max_project_budget'] = this.maxProjectBudget;
    data['min_project_budget'] = this.minProjectBudget;
    data['numberofproject'] = this.numberofproject;
    data['cloudinary_id'] = this.cloudinaryId;
    data['profile_url'] = this.profileUrl;
    if (this.productAsignList != null) {
      data['ProductAsignList'] =
          this.productAsignList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedAt {
  Date? date;

  CreatedAt({this.date});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json[r'$date'] is Map ? new Date.fromJson(json[r'$date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['$date'] = this.date!.toJson();
    }
    return data;
  }
}

class Date {
  String? numberLong;

  Date({this.numberLong});

  Date.fromJson(Map<String, dynamic> json) {
    numberLong = JsonHelper.toStringValue(json[r'$numberLong']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$numberLong'] = this.numberLong;
    return data;
  }
}

class ProductAsignList {
  String? brandId;
  String? brandTitle;
  String? brandImage;
  String? categoryId;
  String? categoryTitle;
  String? categoryImage;
  List<String>? subcategories;

  ProductAsignList(
      {this.brandId,
        this.brandTitle,
        this.brandImage,
        this.categoryId,
        this.categoryTitle,
        this.categoryImage,
        this.subcategories});

  ProductAsignList.fromJson(Map<String, dynamic> json) {
    brandId = JsonHelper.toStringValue(json['brand_id']);
    brandTitle = JsonHelper.toStringValue(json['brand_title']);
    brandImage = JsonHelper.toStringValue(json['brand_image']);
    categoryId = JsonHelper.toStringValue(json['category_id']);
    categoryTitle = JsonHelper.toStringValue(json['category_title']);
    categoryImage = JsonHelper.toStringValue(json['category_image']);
    subcategories = JsonHelper.stringList(json['subcategories']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_id'] = this.brandId;
    data['brand_title'] = this.brandTitle;
    data['brand_image'] = this.brandImage;
    data['category_id'] = this.categoryId;
    data['category_title'] = this.categoryTitle;
    data['category_image'] = this.categoryImage;
    data['subcategories'] = this.subcategories;
    return data;
  }
}

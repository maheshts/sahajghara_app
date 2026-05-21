import 'dart:ffi';

class ProfileResponse {
  Result? result;
  bool? hasError;
  String? message;

  ProfileResponse({this.result, this.hasError, this.message});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? name;
  String? phone;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  String? password;
  String? addressDetails;
  String? remark;
  String? type;
  Null? alternateNumber;
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
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    createdAt = json['createdAt'] != null
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    password = json['password'];
    addressDetails = json['address_details'];
    remark = json['remark'];
    type = json['type'];
    alternateNumber = json['alternate_number'];
    email = json['email'];
    enableVendor = json['enable_vendor'];
    enableContractor = json['enable_contractor'];
    requestContractor = json['request_contractor'];
    contractorCode = json['contractor_code'];
    lat = json['lat'];
    long = json['long'];
    vendorCode = json['vendor_code'];
    requestVendor = json['request_vendor'];
    experience = json['experience'];
    grade = json['grade'];
    maxProjectBudget = json['max_project_budget'];
    minProjectBudget = json['min_project_budget'];
    numberofproject = json['numberofproject'];
    cloudinaryId = json['cloudinary_id'];
    profileUrl = json['profile_url'];
    if (json['ProductAsignList'] != null) {
      productAsignList = <ProductAsignList>[];
      json['ProductAsignList'].forEach((v) {
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
    date = json['$date'] != null ? new Date.fromJson(json['$date']) : null;
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
    numberLong = json['$numberLong'];
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
    brandId = json['brand_id'];
    brandTitle = json['brand_title'];
    brandImage = json['brand_image'];
    categoryId = json['category_id'];
    categoryTitle = json['category_title'];
    categoryImage = json['category_image'];
    subcategories = json['subcategories'].cast<String>();
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

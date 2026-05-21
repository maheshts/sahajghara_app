import '../home/HomePageResponse.dart';

class VendorListResponse {
  Result? result;
  bool? hasError;
  String? message;

  VendorListResponse({this.result, this.hasError, this.message});

  VendorListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Vendorlist>? vendorlist;

  Result({this.vendorlist});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['vendorlist'] != null) {
      vendorlist = <Vendorlist>[];
      json['vendorlist'].forEach((v) {
        vendorlist!.add(new Vendorlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendorlist != null) {
      data['vendorlist'] = this.vendorlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendorlist {
  String? sId;
  String? type;
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  String? alternateNumber;
  String? addressDetails;
  String? remark;
  UpdatedAt? updatedAt;
  UpdatedAt? createdAt;
  String? lat;
  String? long;
  String? vendorCode;
  List<ProductAsign>? productAsign;

  Vendorlist(
      {this.sId,
        this.type,
        this.name,
        this.email,
        this.phone,this.photoUrl,
        this.alternateNumber,
        this.addressDetails,
        this.remark,
        this.updatedAt,
        this.createdAt,
        this.lat,
        this.long,this.vendorCode,
        this.productAsign});

  Vendorlist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    name = json['name'];
    email = json['email'];
    photoUrl = json['profile_url'];
    phone = json['phone'];
    alternateNumber = json['alternate_number'];
    addressDetails = json['address_details'];
    remark = json['remark'];
    updatedAt = json['updatedAt'] != null
        ? new UpdatedAt.fromJson(json['updatedAt'])
        : null;
    createdAt = json['createdAt'] != null
        ? new UpdatedAt.fromJson(json['createdAt'])
        : null;
    lat = json['lat'];
    long = json['long'];
    vendorCode = json['vendor_code'];
    if (json['ProductAsign'] != null) {
      productAsign = <ProductAsign>[];
      json['ProductAsign'].forEach((v) {
        productAsign!.add(new ProductAsign.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profile_url'] = this.photoUrl;
    data['alternate_number'] = this.alternateNumber;
    data['address_details'] = this.addressDetails;
    data['remark'] = this.remark;
    if (this.updatedAt != null) {
      data['updatedAt'] = this.updatedAt!.toJson();
    }
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['vendor_code'] = this.vendorCode;
    if (this.productAsign != null) {
      data['ProductAsign'] = this.productAsign!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpdatedAt {
  Date? date;

  UpdatedAt({this.date});

  UpdatedAt.fromJson(Map<String, dynamic> json) {
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

class ProductAsign {
  Brand? brand;
  Brand? category;

  ProductAsign({this.brand, this.category});

  ProductAsign.fromJson(Map<String, dynamic> json) {
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    category =
    json['category'] != null ? new Brand.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}
//
// class Brand {
//   String? oid;
//
//   Brand({this.oid});
//
//   Brand.fromJson(Map<String, dynamic> json) {
//     oid = json['$oid'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$oid'] = this.oid;
//     return data;
//   }
// }
